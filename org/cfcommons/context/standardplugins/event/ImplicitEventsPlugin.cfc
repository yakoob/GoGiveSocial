import org.cfcommons.context.*;

component implements="org.cfcommons.context.Plugin" {

	public ImplicitEventsPlugin function init() {
	
		variables.broadcasters = {};
		variables.listeners = {};
	
		return this;
	}

	public void function read(required any class) {
	
		var broadcasters = arguments.class.getMethodsAnnotatedAs("event:broadcaster");
		var listeners = arguments.class.getMethodsAnnotatedAs("event:listener");
		
		// if all arrays are empty, then move on
		if (!arrayLen(broadcasters) && !arrayLen(listeners))
			return;
												
				
		for (broadcaster in local.broadcasters) {
		
			var className = broadcaster.getParentClass().getFullName();
			
			if (!structKeyExists(variables.broadcasters, className) || 
				!isArray(variables.broadcasters[className])) {
			
				variables.broadcasters[className] = [];
			}
			
			variables.broadcasters[className].add(broadcaster);
		}
		
		for (listener in local.listeners) {
			var listeningFor = listener.getAnnotation("event:listener");
			
			if (!structKeyExists(variables.listeners, listeningFor) || 
				!isArray(variables.listeners[listeningFor])) {
			
				variables.listeners[listeningFor] = [];
			}
			
			variables.listeners[listeningFor].add(listener);
		}
	
	}
	
	public void function finalize() {
			
		// make sure to register the decorator
		var decorator = new EventBroadcastDecorator();
		decorator.setContext(variables.context);
		decorator.setBroadcasters(variables.broadcasters);
		decorator.setListeners(variables.listeners);
		
		// now register the decorator with the central object factory
		variables.context.getObjectFactory().addDecorator(decorator);
	}
		
	private void function addAnnouncements(required array pointCuts, required string joinPoint) {

	}
	
	private void function addEvents(required array events) {

	}
	
	public void function postContextConstruct() {
	}

	public numeric function getVersion() {
		return 1.0;
	}

	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
}