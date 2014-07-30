import org.cfcommons.context.*;
import org.cfcommons.context.util.*;
import org.cfcommons.reflection.*;
import org.cfcommons.reflection.impl.*;

component implements="org.cfcommons.context.ContextFactory" {

	public PluggableContextFactory function init() {
		return this;
	}
	
	/**
	 * Creates a Context from the provided xmlconfig path AND environment specification.  "Environment"
	 * argument must be a string that represents a valid configured environment in the xml configuration
	 * file, otherwise an exception will be thrown.
	 */
	public Context function createNewContext(required xml xmlconfig, required string environment) {
	
		var context = new HTTPContext();
		
		// load the configuration
		var config = new DefaultXMLConfiguration(xmlConfiguration=arguments.xmlconfig);
		
		// make sure the context knows about it's own configuration
		context.setConfig(config);
		
		if (!config.hasEnvironment(arguments.environment)) {
			throw(message="Context cannot load a non-existent environment",
				detail="Environment named #arguments.environment# has not been configured.")
		}
		
		// trace(type="information", text="PluggableContextFactory: Creating a context for environment named: " & 
			arguments.environment);
		
		var environmentInstance = config.getEnvironment(arguments.environment);
		var environmentConfig = environmentInstance.getConfig();
		var root = environmentConfig.getRoot();
		
		// we'll expand the root directory reference it if we need to.
		var contextRoot = directoryExists(root) ? root : expandPath(root);
		
		// last validation step
		if (!directoryExists(contextRoot)) {
			throw(type="AmbiguousContextRootException", message="Unable to determine the exact system path of the
				context root you would like to create.", detail="The context root: #contextRoot# does not appear to
				be a valid system directory location.");
		}
		
		// trace(type="information", text="PluggableContextFactory: Context root is: " & contextRoot);
		
		// first things first - set the context root
		context.setRoot(contextRoot);
				
		// get all plugins for the declared environment
		var plugins = getPluginInstances(environmentConfig);
						
		// now register each plugin with the context
		var i = 1;
		for (; i <= arraylen(plugins); i++) {
			var plugin = plugins[i];
			plugin.setContext(context);
			context.addPlugin(plugin);
		}				
				
		// ensure everything is all wrapped up and ready to go
		context.finalize();
		
		return context;
	}
	
	/**
	 * This creates and returns an array of actual Plugin instances based off of the registered
	 * EnvironmentPluginConfig[] with the EnvironmentConfig.
	 */
	public any function getPluginInstances(required EnvironmentConfig environmentConfiguration) {
		// trace(type="information", text="PluggableContextFactory: Instantiating and initializing all registered plugins.");
		var configs = environmentConfiguration.getPluginConfigs();
		var plugins = [];
		// now iterate through them and instantiate them
		var i = 1;
		for (; i <= arrayLen(configs); i++) {
			var config = configs[i];
			var instance = createObject("component", config.getClass());
			
			// does this instance have an init method?
			if (structKeyExists(instance, "init"))
				instance = instance.init(argumentCollection=config.getInitArgs());
				
			// add the instantiated plugin to the array to be returned
			arrayAppend(plugins, instance);
		}
		
		return plugins;
	}

}