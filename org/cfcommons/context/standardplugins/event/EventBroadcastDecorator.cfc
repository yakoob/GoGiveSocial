import org.cfcommons.aop.impl.*;
import org.cfcommons.context.*;

component implements="org.cfcommons.context.ObjectDecorator" {

	public EventBroadcastDecorator function init() {
		variables.aopInterceptor = new ObjectScopeInterceptor();
		variables.dispatcher = new EventDispatcher();
		variables.broadcasters = {};
		variables.listeners = {};
		return this;
	}

	public any function decorate(required any object, required string className) {
									
		// decorate the object with the security provider IF it exists in the registry
		if (!structKeyExists(variables.broadcasters, arguments.className))
			return arguments.object;
			
		// if this object has already been decorated for security - then it's probably a singleton
		if (structKeyExists(arguments.object, "$fires$events"))
			return arguments.object;
			
		// obtain all of the registered broadcasters for this class (array of methods)
		var broadcasters = variables.broadcasters[arguments.className];
				
		// need to aop each broadcaster with a set of corresponding listeners
		for (broadcaster in local.broadcasters) {
		
			// trace(type="information", text="Adding interceptor to broadcaster #broadcaster.getParentClass().getFullName()#.#broadcaster.getName()#");
			
			var eventName = broadcaster.getAnnotation("event:broadcaster");
			var interceptedMethod = broadcaster.getName();
			var listeners = variables.listeners[eventName];
				
			var invokeArgs = {
					_eventName = eventName
				,	_listeners = listeners
				,	_context = variables.context
			};
							
			variables.aopInterceptor.interceptAt(object=arguments.object, interceptedMethod=interceptedMethod, aspectInstance=variables.dispatcher, 
				aspectName="fireEvents", position="after", invokeArgs=invokeArgs);
			
		}
										
		return arguments.object;
	}
	
	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	public void function setBroadcasters(required struct broadcasters) {
		variables.broadcasters = arguments.broadcasters;
	}
	
	public void function setListeners(required struct listeners) {
		variables.listeners = arguments.listeners;
	}
	
}