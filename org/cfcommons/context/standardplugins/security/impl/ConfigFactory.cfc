import org.cfcommons.context.standardplugins.security.*;

component {

	public ConfigFactory function init() {
		return this;
	}
	
	public Config function getConfigurationFromXml(required xml xmlConfig) {
		var config = new DefaultConfig();
				
		// first, extract the value of the security-provider IF it exists
		if (structKeyExists(xmlConfig.security, "security-provider"))
			var providerClass = xmlConfig.security["security-provider"].xmlText;
		else
			var providerClass = "org.cfcommons.context.standardplugins.security.impl.DefaultSecurityProvider";
			
		config.setSecurityProviderClass(providerClass);
		
		// now pull out the values for the login and logout nodes
		if (structKeyExists(xmlConfig.security, "login")) {
			config.setLoginRedirect(xmlConfig.security.login.xmlAttributes.redirect);
			
			if (structKeyExists(xmlConfig.security.login.xmlAttributes, "template"))
				config.setLoginFormTemplatePath(xmlConfig.security.login.xmlAttributes.template);
			
			if (structKeyExists(xmlConfig.security.login.xmlAttributes, "url"))
				config.setLoginURL(xmlConfig.security.login.xmlAttributes.url);
		}
			
		if (structKeyExists(xmlConfig.security, "logout")) {
			config.setLogoutRedirect(xmlConfig.security.logout.xmlAttributes.redirect);
			
			if (structKeyExists(xmlConfig.security.logout.xmlAttributes, "url"))
				config.setLogoutUrl(xmlConfig.security.logout.xmlAttributes..url);
		}
		
		if (structKeyExists(xmlConfig.security, "dummy-users") && arrayLen(xmlConfig.security["dummy-users"].xmlChildren))
			var users = parseDummyUsers(xmlConfig.security["dummy-users"].xmlChildren);	
		else
			var users = [];
			
		config.setDummyUsers(users);
		
		// if no requests are being secured - return the config
		if (!structKeyExists(xmlConfig.security, "requests") || !arrayLen(xmlConfig.security.requests.xmlChildren))
			return config;
		
		var requestConfigurations = [];
			
		// iterate over these and add them to an array to be given to the config
		var i = 1;
		for (; i <= arrayLen(xmlConfig.security.requests.xmlChildren); i++) {
			var node = xmlConfig.security.requests.xmlChildren[i];
			var requestConfig = new DefaultSecuredRequest();
			
			requestConfig.setUrl(node.xmlAttributes.url);
			requestConfig.setExpression(node.xmlAttributes.expression);
			
			// httpMethod is an optiona list of specific httpMethods
			if (!structKeyExists(node.xmlAttributes, "httpMethod"))
				requestConfig.setHttpMethod("GET,PUT,POST,DELETE,TRACE,OPTIONS");
			else
				requestConfig.setHttpMethod(node.xmlAttributes.httpMethod);
				
			// now add this to the configurations array
			arrayAppend(requestConfigurations, requestConfig);
		}
		
		// now add this array to the config
		config.setSecuredRequests(requestConfigurations);
				
		return config;
	}
	
	public DummyUser[] function parseDummyUsers(required array usersConfig) {
		var results = [];
		// loop through and create a dummy user instance for each declaration
		var i = 1;
		for (; i <= arrayLen(arguments.usersConfig); i++) {
			var user = arguments.usersConfig[i];
			var dummyUser = new DefaultDummyUser();
			
			dummyUser.setUsername(user.xmlAttributes.name);
			dummyUser.setPassword(user.xmlAttributes.password);
			dummyUser.setKeys(user.xmlAttributes.keys);
			
			arrayAppend(results, dummyUser);
		}
		
		return results;
	}

}