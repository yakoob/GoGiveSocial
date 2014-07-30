import org.cfcommons.reflection.*;
import org.cfcommons.reflection.impl.*;
import org.cfcomons.context.*;

interface {

	public ObjectFactory function getObjectFactory();

	/*
	 * Reflection API
	 */
	public void function setRoot(required string root);
	public void function addClass(required Class class);
	public boolean function hasClass(required string classpath);
	public Class function getClass(required string classpath);
	
	/*
	 * Collaborrative plugin API
	 */
	public void function addPlugin(required Plugin plugin);
	public boolean function hasPlugin(required string pluginName);
	public Plugin function getPlugin(required string pluginName);
	
	/*
	 * Exception handling
	 */
	public void function addExceptionHandler(required ExceptionHandler handler);
	public boolean function hasExceptionHandler(required string type);
	public ExceptionHandler function getExceptionHandler(required string type);
	
	/**
	 * This method allows us to create a central context-specific factory
	 * responsible for instantiating objects.  That way if plugins need
	 * to augment this in order to accound for dependency injection or
	 * other types of object decoration - we've got it.
	 */
	public any function getObjectInstance(required string class, struct initArgs=structNew());
	
	/**
	 * This method should be invoked to clean up / finalize / make ready
	 * the implementing context.
	 */
	public void function finalize();
	
	/**
	 * This method must return a unique value representing the contents
	 * of the context - a hash representing all classes, plugins, and exception
	 * handlers.  This value must be consistent if the context contents do not change.
	 */
	public string function getVersion();
	
	/**
	 * Returns an array of Class implementations representing
	 * subclasses if the underlying component / interface 
	 * represented by the Class argument is being extended 
	 * by any other classes within the context.
	 */
	public Class[] function getSubclasses(required Class class);
	
	/**
	 * Returns an array of Class instances representing components
	 * that implement (as an interface) the provided Class.  Class
	 * types passed in as an argument that do not represent an interface
	 * (where getType() == 'component') will cause this method to throw
	 * an exception of type 'InvalidClassArgument'.
	 */
	public Class[] function getImplementations(required Class class);
	
}