import org.cfcommons.aop.*;

/**
 * <p>
 * The SimpleMethodScopeInterceptor exposes an API that allows the application
 * of AOP aspects to specific object instance methods.  These aspects
 * can be made to intercept a method invocation on a target object in one of 
 * three "positions"; before the invocation occurs, after the invocation occurs, and
 * around the invocation.
 * </p>
 * 
 * <p>
 * "Around" aspects behave differently than "before" or "after" instances in 
 * that a target class method can only have one "around" aspect registered.  Once an
 * "around" aspect is applied to a method, it becomes the responsibility of the applied
 * aspect to invoke the target instance method, otherwise it will not occur."It is
 * also the responsibility of the "around" advice to invoke the target method on
 * the decorated class.
 * </p>
 *
 * <p>
 * Aspects types are independent custom method references (UDF's).  
 * Any instance scope variables (variables.) declared
 * within the aspect "advice" function will reference the scope of the target object whose method
 * is being intercepted - NOT the object within which the aspect method was declared.
 * </p>
 */
component implements="org.cfcommons.aop.Interceptor" extends="org.cfcommons.aop.impl.AbstractInterceptor" {
	
	public MethodScopeInterceptor function init() {
		return this;
	}
	
	/**
	 * Applies a UDF as an aspect in any of of the three supported "positions" (before, after, around) on
	 * a target method (interceptedMethod) on a specific object instance (object).
	 */
	public void function interceptAt(required any object, required string interceptedMethod, required any aspectInstance,
		required string aspectName, required string position, struct invokeArgs=structNew()) {
		
		// this argument gets passed in by our friend the ObjectScopeInterceptor to bypass this check
		if (isNull(arguments.objectoverride) && !isCustomFunction(arguments.aspectInstance)) {
			throw(type="InvalidAspectInstance", message="AspectInstances for a MethodScopeInterceptor must be of type
				custom function.");
		}
		
		super.interceptAt(argumentCollection=arguments);
	}

}