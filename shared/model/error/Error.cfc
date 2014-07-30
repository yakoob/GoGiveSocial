component {
	
	variables.messages.earray = [];
	
	public Error function init(){		
		variables.messages["earray"] = [];
		return this;
	}
	
	public void function add(required any message){		
		if (!arrayFindNocase(variables.messages.earray, arguments.message))
			arrayAppend(variables.messages.earray, arguments.message);		
		
	}	
	
	public boolean function has(){
		return arraylen(list()) ? true : false;
	}
	
	public void function combine(required array hash){
		for (local.a in arguments.hash)
			arrayAppend(variables.messages.earray, a);	
	}
	
	public array function list(){
		return variables.messages.earray;
	}
	
	public numeric function count(){
		var total = 0;
		local.total = local.total + arrayLen(variables.messages.earray);		
		return local.total;
	}
	
	public void function clear(){
		variables.messages.earray = [];		
	}
	
}
