import org.cfcommons.context.*;
import org.cfcommons.context.util.*;
import org.cfcommons.reflection.*;
import org.cfcommons.reflection.impl.*;

component implements="org.cfcommons.context.Context" 
	extends="org.cfcommons.context.impl.ReflectiveContext" accessors="true" {

	property name="plugins" type="array" setter="false";
	property name="objectFactory" type="ObjectFactory";

	/**
	 * Optionally accepts a "root" argument which will construct the internal
	 * reflective Class structure by invoking the setRoot() method.  If no root
	 * argument is passed into this constructor, then you must provide one or 
	 * more root elements after instantiation via the addRoot() method.
	 */
	public PluggableContext function init(string root) {
	
		variables.plugins = [];
		variables.exceptionHandlers = {};
		
		// need an instance of the MutableObjectFactory
		variables.objectFactory = new MutableObjectFactory();
		variables.objectFactory.setContext(this);
		
		super.init(argumentCollection=arguments);
					
		return this;
	}
	
	/**
	 * Will return an instance of the Class as provided by the 'class' argument,
	 * which should represent the full name of the Class (dot-notation path).  Can 
	 * also optionally be provided a structure whose keys will be bound to the constructor
	 * (if one exists) of the class in question.
	 *
	 * This method will delegate object instantiation to the registered ObjectFactory,
	 * which will employ any number of previously registered object decorators in order
	 * to produce a valid object instance.
	 */
	public any function getObjectInstance(required string class, struct initArgs=structNew()) {
		return variables.objectFactory.getObjectInstance(arguments.class, arguments.initArgs);
	}
				
	public void function finalize() {
		
		// now read in each class
		for (className in variables.classes) {
			addClassToPlugins(class=variables.classes[className]);
		}
	
		/**
		 * Invoke finalize() on each registered plugin.
		 */
		for (var i = 1; i <= arrayLen(variables.plugins); i++) {
			var plugin = variables.plugins[i];
			plugin.finalize();
		}
		
		/**
		 * And finally, invoke postContextContruct() on each
		 * registered plugin.
		 */
		for (var i = 1; i <= arrayLen(variables.plugins); i++) {
			var plugin = variables.plugins[i];
			plugin.postContextConstruct();
		}
				
	}
	
	private void function addClassToPlugins(required Class class) {
		for (var i = 1; i <= arrayLen(variables.plugins); i++) {
			var plugin = variables.plugins[i];
			plugin.read(arguments.class);
		}
	}
	
	/**
	 * The PluggableContext expresses a dynamic API consisting of each public method
	 * that each plugin has exposed - the context simply acts as a delegate
	 * proxy to each plugin.  To invoke a method - a call to the context
	 */
	public any function onMissingMethod(required string missingMethodName, 
		required struct missingMethodArguments) {
		
		var invalidMethodNames = ["init","read","finalize","postContextConstruct","getVersion","setContext","getResponse"];
		for (var i = 1; i <= arrayLen(variables.plugins); i++) {
			var plugin = variables.plugins[i];
			
			if (!structKeyExists(plugin, arguments.missingMethodName))
				continue;
				
			return evaluate("plugin.#arguments.missingMethodName#(argumentCollection=arguments.missingMethodArguments)");
		}
		
		// if we've made it this far, then no method was found
		throw("The method #arguments.missingMethodName# was not found in any context plugin or in the Context API.");		
	}
	
	/**
	 * This method registers a new plugin with the context.  It also will iterate through
	 * the internal context Class collection and recursively invoke the read() method
	 * on the provided plugin, passing in order each registered Class instance.
	 */
	public void function addPlugin(required Plugin plugin) {
	
		// need some info on the plugin - set it up
		var data = getMetaData(arguments.plugin);
		// trace(type="information", text="Context: Registering plugin #data.fullname# with the parent context.");
		
		// required to ask for a plugin later on
		arguments.plugin.$contextname = data.fullname;
		arguments.plugin.setContext(this);
		
		arrayAppend(variables.plugins, arguments.plugin);
	}
	
	/**
	 * Will return a boolean result indicating whether or 
	 * not a plugin with the name provided in the 'pluginName' argument
	 * exists within the current Context instance.
	 */
	public boolean function hasPlugin(required string pluginName) {
		
		try {
			getPlugin(pluginName=arguments.pluginName);
		} catch (UnregisteredPluginException e) {
			return false;
		}
		
		return true;
	}
	
	/**
	 * Will return the Plugin instance as specified by name
	 * with the 'pluginName' argument.  This argument must be
	 * the fully qualified dot-notation path to a previously
	 * registered plugin.  If the plugin in question does not
	 * exist within the plugin, then an exception of type
	 * UnregisteredPluginException will be thrown.
	 */
	public Plugin function getPlugin(required string pluginName) {
		
		for (var i = 1; i <= arraylen(variables.plugins); i++) {
			var plugin = variables.plugins[i];
			if (plugin.$contextname == arguments.pluginName)
				return plugin;
		}
		
		throw(type="UnregisteredPluginException",
			message="Plugin '#arguments.pluginName#' has not been registered with the parent context.");
	}
	
	/**
	 * Will introspect each root directory provided for the context
	 * to determine which, if any files have been changed since 
	 * the context was initialized OR since the last time this
	 * method was invoked.  
	 *
	 * If a file has been changed, then the context will automatically
	 * reload it as well as any dependencies (see reloadClass() for more information).
	 * If a new class is detected then it will be registered.
	 */
	public void function reload() {
	
		var changedFiles = [];
		
		for (var r = 1; r <= arrayLen(variables.roots); r++) {	
			var root = variables.roots[r];
			var contents = directoryList(root, true, "query", "*.cfc");
			// iterate throught the contents and create AND register an instance of ComponentClass
			for (var i = 1; i <= contents.recordcount; i++) {
			
				var record = contents.directory[i] & "\" & contents.name[i];
													
				// we only care about files ending with *.cfc
				if (listLast(record, ".") != "cfc")
					continue;
					
				var version = hash(contents.datelastmodified[i]);
				
				// don't reload or recreate a file that already has been
				if (arrayContains(changedFiles, record)) {
					continue;
				// account for new classes
				} else if (!structKeyExists(variables.versions, record)) {
					var class = new ComponentClass(resolvedPath=record);
					addClass(class);
					addClassToPlugins(class=variables.classes[className]);
					arrayAppend(changedFiles, record);
				// account for changed classes
				} else if (variables.versions[record] != version) {
					reloadClass(getDotNotationClassPath(record));
					addClassToPlugins(class=variables.classes[className]);
					arrayAppend(changedFiles, record);
				}
				
				
				// make sure to update the versions registry
				variables.versions[record] = version;
			}
		}
					
	}
	
	private string function getDotNotationClassPath(required string absolutePath) {
	
		var sysRoot = expandPath("/");
			
		// check to see if the sytem path exists within the absolute path
		if (!findNoCase(sysRoot, arguments.absolutePath))
			return arguments.absolutePath;
	
		var path = replaceNoCase(arguments.absolutePath, sysRoot, "", "one");
		path = replace(path, ".cfc", "", "one");
		path = replace(path, "\", ".", "all");
		
		return path;
	}
	
	public void function addExceptionHandler(required ExceptionHandler handler) {
		structInsert(variables.exceptionHandlers, arguments.handler.getType(), arguments.handler);
	}
	
	public boolean function hasExceptionHandler(required string type) {
		return structKeyExists(variables.exceptionHandlers, arguments.type);
	}
	
	public ExceptionHandler function getExceptionHandler(required string type) {
		return variables.exceptionHandlers[arguments.type];
	}
				
}