import org.cfcommons.context.*;
import org.cfcommons.context.impl.*;
import org.cfcommons.context.standardplugins.security.*;
import org.cfcommons.context.standardplugins.security.impl.*;
import org.cfcommons.reflection.impl.*;

component accessors="true" implements="org.cfcommons.context.HTTPPlugin" {

	property SecurityProvider securityProvider;

	public SimpleSecurityPlugin function init(string xmlConfig) {
	
		variables.secureURLFilters = [];
		variables.loginRedirect = "/no_login_redirect_configured";
		variables.logoutRedirect = "/no_logout_redirect_configured";
		variables.loginFormTemplate = "";
		variables.loginURL = "";
		variables.logoutURL = "";
		
		variables.securedMethodMap = {};
	
		// trace(type="information", text="SimpleSecurityPlugin: Initializing plugin.");
		
		if (isNull(variables.securityProviderClass))
			variables.securityProviderClass = "org.cfcommons.context.standardplugins.security.impl.DefaultSecurityProvider";
			
		// trace(type="information", text="SimpleSecurityPlugin: Initializing security provider: #variables.securityProviderClass#");
		
		// TODO: swap this out with a reference to the context createObjectInstance();
		variables.securityProvider = createObject("component", variables.securityProviderClass);
		
		if (isNull(arguments.xmlConfig))
			return this;
		
		// trace(type="information", text="SimpleSecurityPlugin: Configuring plugin with provided xml config.");
		
		var config = getConfigFromXmlFile(arguments.xmlConfig);
		
		configure(config);
		
		return this;
	}
	
	private Config function getConfigFromXmlFile(required string xmlFilePath) {
	
		// optional initialization and conifiguration via an xml file
		if (!fileExists(arguments.xmlFilePath))
			arguments.xmlFilePath = expandPath(arguments.xmlFilePath);
			
		// check again
		if (!fileExists(arguments.xmlFilePath)) {
			throw(type="InvalidConfigFilePath", message="Unable to initialize the SimpleSecurityPlugin",
				detail="The XML configuration file cannot be located at the file provided file path: #arguments.xmlFilePath#. 
				Please ensure the file exists.");
		}
	
		var configFactory = new ConfigFactory();
		var config = configFactory.getConfigurationFromXml(xmlParse(arguments.xmlFilePath));
		
		return config;
	}
	
	private void function configure(required Config configuration) {
	
		var config = arguments.configuration;
		
		variables.securityProviderClass = config.getSecurityProviderClass();
		
		var secureRequestConfigurations = config.getSecuredRequests();
		
		variables.loginRedirect = config.getLoginRedirect();
		variables.loginFormTemplate = config.getLoginFormTemplatePath();
		variables.logoutRedirect = config.getLogoutRedirect();
		variables.loginURL = config.getLoginURL();
		variables.logoutURL = config.getLogoutURL();
		
		// register each secured request declaration
		var i = 1;
		for (; i <= arrayLen(secureRequestConfigurations); i++) {
			var requestConfig = secureRequestConfigurations[i];
			var filter = new SecurityURLFilter();
			
			// now initialize the individual filter
			filter.setHttpMethods(requestConfig.getHttpMethod());
			filter.setTemplate(requestConfig.getUrl());
			filter.setSecurityExpression(requestConfig.getExpression());
			
			// add the filter to the stack
			arrayAppend(variables.secureURLFilters, filter);
		}
		
		// add dummy users to the security provider
		var dummyUsers = config.getDummyUsers();
				
		if (isNull(dummyUsers) || !arrayLen(dummyUsers))
			return;
			
		var i = 1;
		for (; i <= arrayLen(dummyUsers); i++) {
			var dummyUser = dummyUsers[i];
			variables.securityProvider.addDummyUser(dummyUser);
		}
		
	}
	
	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	private void function processLogin() {
		var success = variables.securityProvider.login();
		if (success) {
			location(cgi.script_name & variables.loginRedirect);
		} else {
			var info = {hello="world"};
			throw(type="SecurityException", message="Login Failed",
				detail="The security credentials you've provided are invalid."
				extendedInfo="#variables.loginURL#");
		}
	}

	private void function processLogout() {
		variables.securityProvider.logout();
		location(cgi.script_name & variables.logoutRedirect);
	}
	
	/**
	 * This plugin of course will apply configured security at the HTTP Request
	 * level within this method, checking for registered securityFilters and 
	 * cycling through those filters to determine if configured security
	 * should be applied.
	 */
	public string function getResponse(string response) {
		
		// trace(type="information", text="SimpleSecurityPlugin: Intercepting HTTP request.");
		
		// if no path information exists, then we don't care about this
		if (isNull(cgi.path_info) || !len(trim(cgi.path_info)))
			return arguments.response;
								
		// first, lets check for a default login request
		if (cgi.path_info == variables.loginURL) {
			// trace(type="information", text="SimpleSecurityPlugin: Login request detected - processing.");
			processLogin();
		}
		
		// now check for a logout request
		if (cgi.path_info == variables.logoutURL && variables.securityProvider.isLoggedIn()) {
			// trace(type="information", text="SimpleSecurityPlugin: Logout request detected - processing.");
			processLogout();
		}
						
		// simply iterate through the matchers to see if we have a winner
		var i = 1;
		for (; i <= arrayLen(variables.secureURLFilters); i++) {
			var matcher = variables.secureURLFilters[i];
						
			// first, check for an http method match
			if (!matcher.hasHttpMethod(cgi.request_method))
				continue;
				
			if (!matcher.matchesURI(cgi.path_info))
				continue;
								
			// trace(type="information", text="SimpleSecurityPlugin: Requested resource is secure - authenticating...");
			
			// apply our security to the matched request
			runSecurity(expression=matcher.getSecurityExpression());
		}
		
		return arguments.response;
	}
	
	/**
	 * This method takes the configured SecurityProvider and invokes
	 * the secure() method with the provider "expression" argument.
	 */
	private void function runSecurity(required string expression) {
		variables.securityProvider.secure(expression=arguments.expression);
	}
	
	public numeric function getVersion() {
		return 1.0;
	}

	public void function read(required any class) {
	
		// we only care about implementations
		if (arguments.class.getType() == "interface")
			return;
			
		// need all class methods that have been annotated for security
		var securedMethods = arguments.class.getMethodsAnnotatedAs(annotation="cfcommons:security:secure");
		var className = arguments.class.getFullName();
		
		// create a map for each method
		for (var i = 1; i <= arrayLen(securedMethods); i++) {
		
			// grab the method and the security expression
			var method = securedMethods[i];
			var expression = method.getAnnotation(name="cfcommons:security:secure");
			var methodName = method.getName();
						
			// trace(type="information", text="SimpleSecurityPlugin: Securing #methodName# on Class #className#");
			
			if (!structKeyExists(variables.securedMethodMap, className))
				variables.securedMethodMap[className] = [];
				
			var instruction = {
				methodName = methodName,
				expression = expression
			};
			
			// add the security instruction to the structure / array
			arrayAppend(variables.securedMethodMap[className], instruction);
		}
	
	}
	
	public void function finalize() {
			
		// there's a problem if the security provider is null at this point
		if (isNull(variables.securityProvider)) {
			throw(message="SecurityProvider is null" detail="You must provide the SimpleSecurityPlugin with a 
				valid implementation of the SecurityProvider interface.");
		}
		
		// make sure the provider knows about the login url if it exists
		if (!isNull(variables.loginURL))
			variables.securityProvider.setLoginURL(variables.loginURL);
	
		// we need to register a custom exception handler with the parent context
		var handler = new BasicExceptionHandler();
		
		handler.setType("SecurityException");
		handler.setClassName("org.cfcommons.context.standardplugins.security.impl.EmptySecurityExceptionHandler");
		handler.setMethodName("handleException");
		handler.setViewTemplate(variables.loginFormTemplate);
		
		// trace(type="information", text="SimpleSecurityPlugin: Registering exception handler of type 
			SecurityException with the parent context.");
			
		variables.context.addExceptionHandler(handler);
		
		// now register our object decorator with the context object factory
		var factory = variables.context.getObjectFactory();
		var decorator = new SecurityObjectDecorator();
		decorator.setSecureMethodRegistry(variables.securedMethodMap);
		decorator.setSecurityProvider(variables.securityProvider);
		factory.addDecorator(decorator);
		
		// if autowiring is happeneing, then we need to make sure that the empty handler is a part of the class collection
		emptyComponentClasshandler = new ComponentClass(class="org.cfcommons.context.standardplugins.security.impl.EmptySecurityExceptionHandler");
		variables.context.addClass(emptyComponentClasshandler);
	}
	
	// not needed
	public void function postContextConstruct() {}

}