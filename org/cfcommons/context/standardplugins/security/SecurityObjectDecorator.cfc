import org.cfcommons.aop.impl.*;
import org.cfcommons.context.*;

component implements="org.cfcommons.context.ObjectDecorator" {

	public SecurityObjectDecorator function init() {
		variables.aopInterceptor = new ObjectScopeInterceptor();
		variables.registry = {};
		return this;
	}

	public any function decorate(required any object, required string className) {
	
		// decorate the object with the security provider IF it exists in the registry
		if (!structKeyExists(variables.registry, arguments.className))
			return arguments.object;
			
		// if this object has already been decorated for security - then it's probably a singleton
		if (structKeyExists(arguments.object, "$secure"))
			return arguments.object;
			
		// create a simple flag on the object in case it's a singleton
		arguments.object.$secure = true;
		
		// time for AOP to do it's job and apply the security provider as advice to each and every secured method
		var securedMethodNames = variables.registry[arguments.className];
		
		for (var i = 1; i <= arrayLen(securedMethodNames); i++) {
		
			var methodName = securedMethodNames[i].methodName;
			var expression = securedMethodNames[i].expression;
			var invokeArgs = {expression = expression};
									
			variables.aopInterceptor.interceptAt(object=arguments.object, interceptedMethod=methodName, aspectInstance=variables.provider, 
				aspectName="secure", position="before", invokeArgs=invokeArgs);
		}
					
		return arguments.object;
	}
	
	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	public void function setSecurityProvider(required SecurityProvider provider) {
		variables.provider = arguments.provider;
	}
	
	public void function setSecureMethodRegistry(required struct registry) {
		variables.registry = arguments.registry;
	}

}