import org.cfcommons.context.*;

/**
 * This Factory object is responsible for producing an instance of
 * a context Class.  When instantiating the object, it allows any number
 * of registered ObjectDecorators to participate in that instances
 * initialization.  ObjectDecorators are handed the newly created object
 * and are allowed to agument that object before the instance is returned
 * by the getObjectInstance() method.
 */
component accessors="true" implements="org.cfcommons.context.ObjectFactory" {

	/**
	 * @getter false
	 */
	property Context context;

	public MutableObjectFactory function init() {
		variables.decorators = [];
		return this;
	}
	
	/**
	 * Returns an instance of an object provided by the className argument.  The className
	 * value must be a dot-notation path to a valid context Class, e.g.; com.mydomain.MyObject
	 *
	 * Any ObjectDecorators that have been registered with the factory will be given an opportunity
	 * to augment the object instance after instantiation in the order in which the decorators
	 * were registered.
	 */
	public any function getObjectInstance(required string className, struct initArgs=structNew()) {
	
		local.instance = createObject("component", arguments.className);
		// trace(type="information", text="Creating instance of " & arguments.className);
		
		if (structKeyExists(local.instance, "init"))
			local.instance.init(argumentCollection=arguments.initArgs);
		
		local.instance = doDecoration(local.instance, arguments.className);
		
		return local.instance;
	}
	
	/**
	 * Similar to the behavior of the getObjectInstance() method, except this method
	 * accepts an already instantiated object reference and then performs decoration.
	 */
	public any function decorateObjectInstance(required any object, required string className) {
		return doDecoration(arguments.object, arguments.className);
	}
	
	public void function addDecorator(required ObjectDecorator decorator) {
		// ensure this plugin has access to the context
		arguments.decorator.setContext(variables.context);
		arrayAppend(variables.decorators, arguments.decorator);
	}
	
	private any function doDecoration(required any object, className) {
	
		// let the decoration begin
		for (var i = 1; i <= arrayLen(variables.decorators); i++) {
			local.decorator = variables.decorators[i];
			arguments.object = local.decorator.decorate(arguments.object, arguments.className);
		}
		
		/*
		 * Each decorate is REQUIRED to return the same instance
		 * of the original object, if the 'instance' variable is null,
		 * then one of the decorators didn't do its job correctly.
		 */ 
		if (isNull(arguments.object)) {
			throw(type="NullDecoratorReturnTypeException" message="A Decorator failed to return a valid instance");
		}
		
		// decorate with the object factory
		if (!structKeyExists(arguments.object, "$setObjectFactory")) {
			arguments.object.$getObjectFactory = getObjectFactoryTemplate;
			arguments.object.$setObjectFactory = setObjectFactoryTemplate;
			
			// inject an instance of this
			arguments.object.$setObjectFactory(this);
		}
	
		return arguments.object;
	}
	
	public ObjectFactory function getObjectFactoryTemplate() {
		return variables.$cfcommons$context$objectFactory;
	}
	
	public void function setObjectFactoryTemplate(required ObjectFactory factory) {
		variables.$cfcommons$context$objectFactory = arguments.factory;
	}

}