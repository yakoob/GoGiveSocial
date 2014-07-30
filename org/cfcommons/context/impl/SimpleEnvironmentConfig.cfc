import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.EnvironmentConfig" {

	property string root;
	property string reloadType;
	property EnvironmentPluginConfig[] pluginConfigs;

	public EnvironmentConfig function init() {
		variables.pluginConfigs = [];
		return this;
	}
	
	public void function addPluginConfig(required EnvironmentPluginConfig config) {
		arrayAppend(variables.pluginConfigs, arguments.config);
	}
	
}