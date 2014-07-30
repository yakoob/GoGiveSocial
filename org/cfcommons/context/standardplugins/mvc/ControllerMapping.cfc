import org.cfcommons.context.*;

component extends="org.cfcommons.http.impl.CFCRequestMap" accessors="true" {

	property Context context;
	property viewPath;
	
	public ControllerMapping function init() {
		super.init();
		return this;
	}
	
	/**
	 * Overriden from superclass
	 * 
	 * We need to ensure that we obtain an instance of the controller
	 * from the centralized context object factory via the classname - the superclass
	 * will accept another object instance - this class must disallow this.
	 */
	public void function setObject(required any object) {
		throw(type="UnsupportedMethodException", message="Object instances are not allowed
			as targets in the ControllerMapping.  Please use setClassName()");
	}
	
	/**
	 * Overriden from superclass
	 *
	 * This overriden method returns local controller method instance variables instead
	 * of the results of the controller method itself.  It also ensures that it obtains
	 * an instance of the controller component from the centralized context object
	 * factory, instead of instantiating a new one directly.
	 */
	public any function mapRequest(required string uri, required struct requestData) {

		/*
		 * Grab and bind all relevant request data to
		 * the invocation of the mapped method on the provided
		 * object instance.
		 */
		var data = super.getRequestVariables(uri=arguments.uri,
			requestData=arguments.requestData);
		
		var args = {};	
		structAppend(local.data, url);
		structAppend(local.data, form);
		structAppend(local.args, local.data);
						
		// set it in the arguments scope but DO NOT overwrite what is already there
		structAppend(local.args, arguments.requestData, false);
		structAppend(local.args, local.data, false);
			
		// make sure that we have either a classname or object instance
		if (isNull(variables.className) || !len(trim(variables.className))) {
			throw(type="NullInstanceInvocationException" message="The class name is not valid or
				has not been set - cannot instantiate an object from an invalid class name.");
		}
		
		// make sure to ask for the object via the context
		var obj = getContext().getObjectInstance(variables.className);
		
		// decorate the controller instance with a means to extract instance variables
		local.obj.$mvc$getControllerVariables = $mvc$getControllerVariables;
				
		// invoke the controller method
		super.doInvocation(instance=local.obj, methodName=variables.methodName,
			args=local.args);
		
		// now return the controllers instance variables
		return obj.$mvc$getcontrollerVariables();
	}

	/**
	 * This method can be used to capture and return
	 * any instance variables that have been set in
	 * a controller method.  This method gets placed on 
	 * controller objects and executes within their scope - 
	 * not within the scope of the ControllerMapping instance.
	 */
	public struct function $mvc$getControllerVariables() {
		var relevantVars = {};
		var key = "";
		for (key in variables) {
			// filter out custom functions and the instance itself
			if (isCustomFunction(variables[key]) || key == "this")
				continue;
			else
				structInsert(relevantVars, key, variables[key]);
		}
		return relevantVars;
	}

}