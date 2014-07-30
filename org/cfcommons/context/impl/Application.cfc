/**
 * This Application.cfc is provided as a convenience when working with
 * HTTPContexts.  It provides default implementations for configuring
 * and creating a CF application managed HTTPContext, including context caching
 * and a means to provide dynamic reloading based off of a provided xml configuration.
 */
component {

	/**
	 * Automatically invokes the loadContext() method to 
	 * ensure that the context is loaded when the CF application
	 * initializes.
	 */
	public function onApplicationStart() {
		loadContext();
	}
	
	/**
	 * Determines based off of the environment reload settings, whether or not to reload the context.
	 */
	public function onRequestStart() {
		if (!structKeyExists(application, "cfcommons") || needsReload())
			loadContext();
	}
	
	/**
	 * Delegates response handling to the HTTPContext's respond() method.  Which 
	 * in turn delegates in order to it's configured HTTPPlugin instances.
	 */
	public function onRequest() {
		// we have an HTTPContext - so ask it to respond
		application.cfcommons.context.ctx.respond();	
	}

	/**
	 * This method loads a new HTTPContext into the application scope variable: application.cfcommons.context.ctx.
	 * You must extend this Application.cfc and provide at least one variable in order to get a properly instantiated
	 * context that can respond to requests;
	 * 
	 * <pre>
	 * this.cfcommons.context.config.env = {env-name};
	 * </pre>
	 *
	 * "env-name" must be replaced by a valid environment name as per the context configuration.xml file.  This
	 * File by convention, can be located within the same directory as the Application.cfc file OR anywhere
	 * the user chooses so long as a path to the file is provided with the this.cfcommons.context.config.file variable
	 *
	 */
	private function loadContext() {
	
		if (isNull(this.cfcommons.context.config.env)) {
			throw(message="You must specify the name of the enviroment mapped to a declared
				configuration in order to initialize your context.");
		}
		
		application.cfcommons.context.config.env = this.cfcommons.context.config.env;
				
		// you can explicitly define where the configuration file is located
		if (!isNull(this.cfcommons.context.config.file)) {
			var config = this.cfcommons.context.config.file;
		} else {
			// check for the context-config.xml file in the same directory as this Application.cfc file
			var config = replaceNoCase(getCurrentTemplatePath(), "Application.cfc", "", "all") & "context-config.xml";
		}
							
		if (!fileExists(config))
			throw("No context-config.xml was found to configure and initialize your HTTP context.");
		
		// create the xml configuration
		var factory = new PluggableContextFactory(); 
	
		// now ask the factory to create the context
		application.cfcommons.context.ctx = factory.createNewContext(xmlconfig=config, 
			environment=this.cfcommons.context.config.env);
						
		// initialize the version
		var version = application.cfcommons.context.ctx.getVersion();
		application.cfcommons.context.currentversion = version;
						
		application.cfcommons.context.config.reload = application.cfcommons.context.ctx.getConfig().
			getEnvironment(this.cfcommons.context.config.env).getConfig().getReloadType();
	}
	
	// reload attribute is only relevent with an HTTPContext managed by this application
	private boolean function needsReload() {
	
		// if the 'environment' variable ever changes, then we always need to reload
		
		var setting = !isNull(application.cfcommons.context.config.reload) ? application.cfcommons.context.config.reload : "always";
		
		if (application.cfcommons.context.config.env != this.cfcommons.context.config.env)
			return true;
			
		if (setting == "never")
			return false;
		
		if (setting == "always")
			return true;
		
		/*
		 * We only want to evaluate the version of the context IF the reload value
		 * is "auto".  There's a performance hit to calculate a context version.
		 */
		if (setting == "auto" && application.cfcommons.context.ctx.getVersion() != application.cfcommons.context.currentversion) {
			return true;	
		}
		
		return false;
	}
	
}