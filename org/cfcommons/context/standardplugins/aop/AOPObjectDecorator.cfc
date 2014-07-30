import org.cfcommons.context.*;
import org.cfcommons.aop.impl.*;

component accessors="true" implements="org.cfcommons.context.ObjectDecorator" {

	property Context context;
	property PointCutRegistry pointCutRegistry;
	property AdviceRegistry adviceRegistry;

	public AOPObjectDecorator function init() {
		return this;	
	}
	
	public any function decorate(required any object, required string className) {
	
		// first, if this object has already been decorated, no need to do it again
		if (structKeyExists(arguments.object, "$cfcommons$aop$decorated"))
			return arguments.object;
	
		// second, check to see if there's an instruction to decorate this object;
		var pointCutRegistry = getPointCutRegistry();
		var adviceRegistry = getAdviceRegistry();
		
		if (!pointCutRegistry.hasPointCut(arguments.className))
			return arguments.object;
			
		// trace(type="information", text="AOPObjectDecorator: Decorating #arguments.className#");	
			
		// time to decorate the object methods that need it
		var class = variables.context.getClass(arguments.className);
		
		// now aspectify the object
		aopIfy(arguments.object, class.getMethodsAnnotatedAs(variables.markers.before), "before");
		aopIfy(arguments.object, class.getMethodsAnnotatedAs(variables.markers.after), "after");
		aopIfy(arguments.object, class.getMethodsAnnotatedAs(variables.markers.around), "around");
		
		return arguments.object;
	}
	
	private void function aopIfy(required any object, required array methods, required string joinpoint) {
		for (var i = 1; i <= arrayLen(arguments.methods); i++) {
		
			var method = arguments.methods[i];
			
			var listOfAdvice = method.getAnnotation(variables.markers[arguments.joinpoint]);
			
			// trim the list
			local.listOfAdvice = replace(local.listOfAdvice, " ", "", "all");
			
			var adviceNames = listToArray(local.listOfAdvice);
						
			for (var a = 1; a <= arrayLen(adviceNames); a++) {
				var name = adviceNames[a];
				// check to make sure a matching advice declaration exists
				if (!adviceRegistry.hasAdvice(name)) {
					throw(type="InvalidAdviceNameReference", message="Advice Not Registered", 
						detail="The advice named #name# has not been declared anywhere within your context.");
				}
				
				var advice = adviceRegistry.getAdvice(name);
				
				// now grab an instance of the advice class
				var adviceInstance = variables.context.getObjectInstance(advice.getClassName());
															
				// now apply that instance as an aspect
				// need an object interceptor from the aop library
				new ObjectScopeInterceptor().interceptAt(object=arguments.object, interceptedMethod=method.getName(), aspectInstance=adviceInstance,
					aspectName=advice.getMethodName(), position=arguments.joinpoint);
					
				// now flag the object
				arguments.object["$cfcommons$aop$decorated"] = true;
			}
		
		}
	}
	
	public void function setMarkers(required struct markers) {
		variables.markers = arguments.markers;
	}
	
}