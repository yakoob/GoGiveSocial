import org.cfcommons.context.*;

/**
 * This plugin provides a fast and efficient Inversion of Control / Dependency Injection
 * mechanism for any type of cfcommons Context.  It performs autowiring by property type, meaning
 * that any properties declared on a context class that are not native CF data-types (i.e., string,
 * boolean, numeric, etc..) will be assumed to be custom types and automatically instantiated and
 * injected into the primary class.
 *
 * <pre>
 * component accessors="true" {
 * 
 *		property name="someDependency" type="com.mydomain.MyObjectDependency";
 *
 * }
 * </pre>
 *
 * The ObjectFactory within the Context will then look for a context class named
 * 'com.mydomain.MyObjectDependency', instantiate it and inject it into the parent class
 * via the method setSomeDependency() (named after the property name itself).
 *
 * All of this is done when the parent Contexts' getObjectInstance()
 * method is invoked;
 *
 * <pre>
 * object = context.getObjectInstance("com.mydomain.MyObject");
 * </pre>
 *
 * Not only will the resulting object be properly injected, but it will have gone through
 * the ObjectFactory's interal object decoration mechanism to ensure that any plugins
 * that exist within the context that have registered ObjectDecorators will play a role (as designed)
 * in object instantiation.
 *
 * Below are the annotations that this plugin looks for in order to perform
 * autowiring and singleton management;
 *
 * @cfcommons:ioc:singleton - this is a class level annotation.  If this exists on the component,
 * then the component will be treated as a singleton, created and initialized only once during the lifetime
 * of the context.
 *
 * @cfcommons:ioc:implementation - in cases where you would like your property to create mutator methods (setters/getters)
 * that work with interface types, you can annotate your property with this and have a concrete object instance injected
 * into the property setter.  The value of this annotation must be a fully-qualified dot-notation path to a valid
 * context class.  Of course, the concrete type must either implement the interface specified by the property type, unless
 * the property type is "any" in which case it won't matter (but you'll lose the benefits of type safety).
 *
 * @cfcommons:ioc:exempt - this is another property-level annotation that will exempt the property from automatic dependency
 * injection.
 *
 * @cfcommons:ioc:initargs - this is a component-level annotation whose value must take the form of an implicit structure with
 * key-value pairs such as; {key1="valueone", key2="valuetwo"} When this annotation exists on the component, each key that maps directly
 * to an argument within the method signature of an "init()" method, its value will be injected.
 *
 * Each one of the above annotations can be "overriden" by providing alternative annotation "markers" in the plugin constructor (init).
 * Any combination of markers can be overriden.  When new values are provided, the new value will replace the default markers and
 * the plugin will look for those annotations instead;
 * 
 * <pre>
 * neodymiumPlugin = new NeoDymiumPlugin(singletonMarker='yoThisIsASingleton', 
 * 		exemptMarker='dontInjectThis', implMarker='concreteImplementation');
 * </pre>
 */
component implements="org.cfcommons.context.Plugin" {

	public NeodymiumPlugin function init(string singletonMarker="cfcommons:ioc:singleton", 
		string exemptMarker="cfcommons:ioc:exempt", string implMarker="cfcommons:ioc:implementation",
		string initArgsMarker="cfcommons:ioc:initargs") {
		
		/*
		 * These are configurable markers used to indicate the actual
		 * class and property level annotations that the plugin will 
		 * look for when determining how to autowire and instantiate
		 * a context class instance.  Default values are provided
		 * in the constructor method signature.
		 */
		variables.annotationMarkers = {
			singletonMarker = arguments.singletonMarker,
			exemptMarker = arguments.exemptMarker,
			implMarker = arguments.implMarker,
			initArgsMarker = arguments.initArgsMarker
		};
		
		return this;
	}

	public numeric function getVersion() {
		return 1.1;
	}

	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	public void function postContextConstruct() {
	
		// now replace the 
		var objectFactory = variables.context.getObjectFactory();
		
		objectFactory.setSingletonCache = $setSingletonCacheTemplate;
		objectFactory.getObjectInstance = $getObjectInstanceTemplate;
		objectFactory.setAnnotationMarkers = $setIOCAnnotationMarkersTemplate;
		
		// inject the empty singleton-cache AND configured annotation markers
		objectFactory.setSingletonCache({});
		objectFactory.setAnnotationMarkers(variables.annotationMarkers);
	
	}
	
	public void function read(required any class) {}
	
	public void function finalize() {
		var decorator = new AutowiringObjectDecorator();
		decorator.setAnnotationMarkers(variables.annotationMarkers);
		// register the autowiring decorator with the central object factory
		variables.context.getObjectFactory().addDecorator(decorator);
	}
	
	public any function $getObjectInstanceTemplate(required string className, struct initArgs=structNew()) {
	
		// first check the singleton cache for an instance of the class
		if (structKeyExists(variables.$ioc$singletonCache, arguments.className)) {
			// trace(type="information", text="MutableObjectFactory - Neo: Returning singleton instance of #arguments.className#");
			return variables.$ioc$singletonCache[arguments.className];
		}
		
		// if you've made it this far - then we need a fresh transient instance
		// trace(type="information", text="MutableObjectFactory - Neo: Creating transient instance of #arguments.className#");
		var instance = createObject("component", arguments.className);
		var class = variables.context.getClass(arguments.className);
		
		// are init args available? if so, inject those as well but ONLY if the object has an init() method
		if (structKeyExists(local.instance, "init")) {
			if (local.class.hasAnnotation(variables.$ioc$annotationMarkers.initArgsMarker)) {
				local.instance.init(argumentCollection=local.class.convertShorthandToStruct(local.class.getAnnotation(variables.$ioc$annotationMarkers.initArgsMarker)));
			} else {
				// simply invoke the constructor
				local.instance.init();	
			}
		}
		
		// is this a singleton that we need to cache?
		if (class.hasAnnotation(variables.$ioc$annotationMarkers.singletonMarker)) {
			// trace(type="information", text="MutableObjectFactory - Neo: Registering singleton #arguments.className#");
			variables.$ioc$singletonCache[arguments.className] = local.instance;
		}
								
		// now decorate with the registered object decorators
		local.instance = doDecoration(local.instance, arguments.className);
											
		return local.instance;
	}
	
	public void function $setSingletonCacheTemplate(required struct cache) {
		variables.$ioc$singletonCache = arguments.cache;
	}
	
	public void function $setIOCAnnotationMarkersTemplate(required struct markers) {
		variables.$ioc$annotationMarkers = arguments.markers;
	}

}