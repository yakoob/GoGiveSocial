component {

	public PointCutRegistry function init() {
		variables.registry = {};
		return this;
	}
	
	public boolean function hasPointCut(required string className, string methodName="") {
	
		if (!structKeyExists(variables.registry, arguments.className))
			return false;
	
		if (structKeyExists(variables.registry[arguments.className], arguments.methodName))
			return true;
			
		if (structKeyExists(variables.registry, arguments.className))
			return true;
			
		return false;
	}
	
	public void function addPointCut(required PointCut pointCut) {
		
		var className = arguments.pointCut.getClassName();
		var methodName = arguments.pointCut.getMethodName();
		
		variables.registry[className][methodName] = arguments.pointCut;
	}
	
	public PointCut function getPointCut(required string className, required string methodName) {
		return variables.registry[arguments.className][arguments.methodName];
	}

}