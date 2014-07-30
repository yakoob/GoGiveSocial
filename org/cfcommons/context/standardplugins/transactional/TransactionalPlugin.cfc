import org.cfcommons.context.*;
import org.cfcommons.transactional.impl.*;

component accessors="true" implements="org.cfcommons.context.Plugin" {
	/**
    * @type org.cfcommons.transactional.impl.TransactionalService
    */
	property transactionalService;
	property struct cache;
		 
	public TransactionalPlugin function init(){
		variables.cache = {};
		setTransactionalService(new TransactionalService());
		return this;
	}
	
	public void function read(required any class){
		var methods = class.getAnnotatedMethods();
		var i = 1;
		
		for(; i <= arrayLen(methods); i++){
			var method = methods[i];

			if(method.hasAnnotation(name = "cfcommons:transactional"))
				mapInstructions(classPath = class.getFullName(), method = method.getName());
		}
	};
	
	private void function mapInstructions(required string classpath, required string method){
		// if the structure does not exist, simply create a new array assign it to the struct key
		if(!structKeyExists(variables.cache, arguments.classpath)){
			variables.cache[arguments.classpath] = [arguments.method];
			return;
		}
		
		// if it does, append the method name to the array for this key.			
		arrayAppend(variables.cache[arguments.classpath], arguments.method);
		return;
	}

	public any function get(required string classpath){
		// class existence check
		if(!structKeyExists(variables.cache, arguments.classpath))
			throw(type="TransactionalClassNotFound"
				, message="The class #arguments.classpath# does not exist in the transactional cache."
				, detail="Check your method annotations in this class to ensure the proper @cfcommons:transactional annotation is being used.");
			
		// method existence check
		return getTransactionalService().makeTransactional(object = arguments.classpath, methods = variables.cache[arguments.classpath]);
			
	}

	public numeric function getVersion(){
		return "1";
	};

	// not needed
	public void function finalize(){};
	// not needed
	public void function postContextConstruct(){};
	
	public void function setContext(required Context context){
		variables.context = arguments.context;
	};

}
