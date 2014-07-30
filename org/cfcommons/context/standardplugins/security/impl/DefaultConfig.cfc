import org.cfcommons.context.standardplugins.security.*;

component accessors="true" implements="org.cfcommons.context.standardplugins.security.Config" {

	property string loginRedirect;
	property string logoutRedirect;
	property string loginURL;
	property string logoutURL;
	property string securityProviderClass;
	property array securedRequests;
	property string loginFormTemplatePath;
	property DummyUser[] dummyUsers;

	public DefaultConfig function init() {
		variables.securityProviderClass = "";
		variables.securedRequests = [];
		
		// initialize to the plugin default location
		variables.loginFormTemplatePath = "/org/cfcommons/context/standardplugins/security/views/default_login.cfm";
		
		variables.loginURL = "/cfcommons_security_login";
		variables.logoutURL = "/cfcommons_security_logout";
		
		return this;
	}

}