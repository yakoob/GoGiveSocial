component accessors="true" implements="org.cfcommons.context.standardplugins.security.DummyUser" {

	property string username;
	property string password;
	property string keys;

	public DefaultDummyUser function init() {
		variables.username = "";
		variables.password = "";
		variables.keys = ""; 
		
		return this;
	}

}