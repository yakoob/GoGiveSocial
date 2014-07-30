import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.Environment" {

	property string name;
	property EnvironmentConfig config;

	public SimpleEnvironment function init() {
		return this;
	}
	
}