import org.cfcommons.context.*;

component {

	public EventDispatcher function init() {
		variables.listeners = {};
		return this;
	}
		
	public struct function fireEvents(required string _eventName, required array _listeners, required Context _context) {
		trace(type="information", text="Firing event #arguments._eventName#");		
		if (!isnull(arguments.success) && !arguments.success)
			return arguments;		
		for (listener in arguments._listeners) {			
			trace(type="information", text="Handling event #arguments._eventName# with #listener.getParentClass().getFullName()#.#listener.getName()#");			
			var instance = arguments._context.getObjectInstance(listener.getParentClass().getFullName());			
			var methodName = listener.getName();				
			if( !isnull(arguments.mainInvocation.success) && arguments.mainInvocation.success ) {				
				evaluate("instance.#methodName#(argumentCollection=arguments)");
			}		
			else if (isnull(arguments.mainInvocation.success))
				evaluate("instance.#methodName#(argumentCollection=arguments)");
		}		
		return arguments;
	}
}