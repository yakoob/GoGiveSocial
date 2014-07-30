import org.cfcommons.context.*;

component implements="org.cfcommons.context.Plugin" {

	public SimpleAOPPlugin function init(string beforeMarker="cfcommons:aop:before:advice", string afterMarker="cfcommons:aop:after:advice",
		string aroundMarker="cfcommons:aop:around:advice", string adviceMarker="cfcommons:aop:advice:name") {
	
		variables.markers = {
				before = arguments.beforeMarker
			,	after = arguments.afterMarker
			,	around = arguments.aroundMarker
			,	advice = arguments.adviceMarker
		};
	
		variables.pointCutRegistry = new PointCutRegistry();
		variables.adviceRegistry = new AdviceRegistry();
	
		return this;
	}

	public void function read(required any class) {
	
		var beforePointCuts = arguments.class.getMethodsAnnotatedAs(variables.markers.before);
		var afterPointCuts = arguments.class.getMethodsAnnotatedAs(variables.markers.after);
		var aroundPointCuts = arguments.class.getMethodsAnnotatedAs(variables.markers.around);
		var advice = arguments.class.getMethodsAnnotatedAs(variables.markers.advice);
		
		// if all arrays are empty, then move on
		if (!arrayLen(beforePointCuts) && !arrayLen(afterPointCuts) && !arrayLen(aroundPointCuts) && !arrayLen(advice))
			return;
			
		var fullName = arguments.class.getFullName();
					
		addPointCuts(beforePointCuts, "before", fullName);
		addPointCuts(afterPointCuts, "after", fullName);
		addPointCuts(aroundPointCuts, "around", fullName);
		addAdvice(advice, fullName);
	
	}
	
	public void function finalize() {
	
		// make sure to register the decorator
		var decorator = new AOPObjectDecorator();
		
		// give it both registries
		decorator.setpointCutRegistry(variables.pointCutRegistry);
		decorator.setAdviceRegistry(variables.adviceRegistry);
		
		// make sure it knows about our 'markers' - it will need it later on
		decorator.setMarkers(variables.markers);
		
		// now register the decorator with the central object factory
		variables.context.getObjectFactory().addDecorator(decorator);
	}
	
	public void function postContextConstruct() {}

	public numeric function getVersion() {
		return 1.0;
	}

	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	private void function addPointCuts(required array pointCuts, required string joinPoint, required string className) {
		for (var i = 1; i <= arrayLen(arguments.pointCuts); i++) {
		
			var aspectedMethod = arguments.pointCuts[i];
			var annotationMarker = variables.markers[arguments.joinPoint];
			var adviceNames = listToArray(aspectedMethod.getAnnotation(local.annotationMarker));
			
			// trace(type="information" text="SimpleAOPPlugin: Registering point-cuts #arrayToList(adviceNames)# for #arguments.className#");
			
			// now create and register the point cut
			var pointcut = new PointCut();
			pointCut.setAdviceNames(adviceNames);
			pointCut.setJoinPoint(arguments.joinPoint);
			pointCut.setClassName(arguments.className);
			pointCut.setMethodName(aspectedMethod.getName());
			
			variables.pointCutRegistry.addPointCut(pointCut);
		}
	}
	
	private void function addAdvice(required array adviceArray, required string className) {
		for (var i = 1; i <= arrayLen(arguments.adviceArray); i++) {
			var aspectedMethod = arguments.adviceArray[i];
			var adviceName = aspectedMethod.getAnnotation(variables.markers.advice);
			
			// trace(type="information" text="SimpleAOPPlugin: Registering advice #adviceName# declared on #arguments.className#");
			
			// now create and register the point cut
			var advice = new Advice();
			advice.setName(trim(adviceName));
			advice.setClassName(arguments.className);
			advice.setMethodName(aspectedMethod.getName());
			variables.adviceRegistry.addAdvice(advice);
		}
	}
	
}