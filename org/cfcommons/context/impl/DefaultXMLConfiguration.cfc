import org.cfcommons.context.*;

component implements="org.cfcommons.context.Config" {

	public Config function init(xml xmlConfiguration) {

		variables.environments = [];
		
		// time to parse out and read the configuration
		if (!isNull(arguments.xmlConfiguration))
			parseConfig(arguments.xmlConfiguration);
		
		return this;
	}
	
	public void function addEnvironment(required Environment environment) {
		arrayAppend(variables.environments, arguments.environment);
	}
	
	public boolean function hasEnvironment(required string environmentName) {
		var i = 1;
		for (; i <= arrayLen(variables.environments); i++) {
			var env = variables.environments[i];
			if (env.getName() == arguments.environmentName)
				return true;
		}
		
		return false;
	}
	
	public Environment function getEnvironment(required string environmentName) {
		var i = 1;
		for (; i <= arrayLen(variables.environments); i++) {
			var env = variables.environments[i];
			if (env.getName() == arguments.environmentName)
				return env;
		}
		
		throw(type="UnmanagedEnvException", message="Unable to locate environment named #environmentName#");
	}
	
	public Environment[] function getEnvironments() {
		return variables.environments;
	}
	
	// TODO: This method is ridiculously complex and needs to be refactored in a big way
	private void function parseConfig(required xml xmlConfiguration) {
		// first, grab all declared environment mappings
		var environments = xmlSearch(xmlConfiguration, "//environment-mappings/env");
		
		// at least one environment must be declared
		if (!arrayLen(environments)) {
			throw(type="NoConfiguredEnvironmentsException", message="Must have at least one declared environment in the environments configuration file.");
		}
		
		// now loop through this and populate each environment
		var i = 1;
		for (; i <= arrayLen(environments); i++) {
		
			var envNode = environments[i];
			var envMappedConfig = envNode.xmlAttributes.config;
			var envName = envNode.xmlAttributes.name;
			var environmentData = xmlSearch(xmlConfiguration, "//configurations/config[@name='#envMappedConfig#']");
			
			// if nothing was found, then the environment was misconfigured
			if (!arrayLen(environmentData)) {
				throw(message="Declared environment #envName# is mapped to the configuration #envMappedConfig# which does not exist.  Please
					check the spelling of your declared configurations.");	
			}
			
			// time to create the environment and the configuration
			var environment = new SimpleEnvironment();
			var environmentConfig = new SimpleEnvironmentConfig();
			
			environment.setName(envName);
			
			// grab and validate reload value
			var reloadData = xmlSearch(xmlConfiguration, "//configurations/config[@name='#envMappedConfig#']/reload");
			
			// validate reload data exists
			if (!arrayLen(reloadData)) 
				throw(message="No reload value was specified for configuration named #envMappedConfig#");
			
			environmentConfig.setReloadType(reloadData[1].xmlText);
			environmentConfig.setRoot(environmentData[1].xmlAttributes.root);
			
			// now pull all plugin information
			var pluginData = xmlSearch(xmlConfiguration, "//configurations/config[@name='#envMappedConfig#']/plugins/plugin");
						
			if (!arrayLen(pluginData))
				throw(message="A valid context configuration must declare at least one plugin.");
				
			// now loop through each plugin configuration and configure it
			var p = 1;
			for (; p <= arrayLen(pluginData); p++) {
				var pData = pluginData[p];
				var classPath = pData.xmlAttributes.class;
				
				// and finall, create the init argument collection
				var argCollection = {};
				var a = 1;
				for (; a <= arrayLen(pData.xmlChildren); a++) {
					var arg = pData.xmlChildren[a];
					argCollection[arg.xmlName] = arg.xmlText;
				}
				
				// hand that info off to a new plugin config
				var pluginConfig = new SimpleEnvironmentPluginConfig();
				
				pluginConfig.setClass(classPath);
				pluginConfig.setInitArgs(argCollection);
				
				// now add the plugin configuration to the environment config
				environmentConfig.addPluginConfig(pluginConfig);
			}
			
			// now add the environment configuration to the enviroment
			environment.setConfig(environmentConfig);
			addEnvironment(environment);
		}
	}

}