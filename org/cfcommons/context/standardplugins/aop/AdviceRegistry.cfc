component {

	public AdviceRegistry function init() {
		variables.registry = {};
		return this;
	}
	
	public boolean function hasAdvice(required string name) {
		return structKeyExists(variables.registry, arguments.name);
	}
	
	public void function addAdvice(required Advice advice) {
		
		var name = arguments.advice.getName();
		
		if (structKeyExists(variables.registry, name))
			return;
		
		variables.registry[name] = arguments.advice;
	}
	
	public Advice function getAdvice(required string name) {
		return variables.registry[arguments.name];
	}

}