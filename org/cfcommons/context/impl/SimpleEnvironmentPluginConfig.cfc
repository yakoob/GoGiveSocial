import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.EnvironmentPluginConfig" {

	property string class;
	property struct initArgs;

	public EnvironmentPluginConfig function init() {
		return this;
	}
	
}