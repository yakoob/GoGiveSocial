component implements="org.cfcommons.aop.Interceptor" extends="org.cfcommons.aop.impl.AbstractInterceptor" {

	public ObjectScopeInterceptor function init() {
		return this;
	}
	
	public void function interceptAt(required any object, required string interceptedMethod, required any aspectInstance,
		required string aspectName, required string position, struct invokeArgs=structNew()) {
	
		// ensure that the aspectInstance is a custom object type
		if (!isObject(arguments.aspectInstance)) {
			throw(type="InvalidAspectInstance", message="You have provided an invalid aspect instance type.
				Valid aspect instances must be instances of a cfcomponent.");
		}
		
		if (!len(trim(arguments.aspectName)) || (!structKeyExists(arguments.aspectInstance, arguments.aspectName))) {
			throw(type="InvalidAspectName", message="You have provided an invalid aspect name of '#arguments.aspectName#'.  Valid
				aspect names must be strings representing a method that exists on the aspectInstance.");
		}
		
		// this is a flag that tells our superclass to bypass the aspectInstance type check
		arguments.objectoverride = true;
		
		super.interceptAt(argumentCollection=arguments);
	}

}