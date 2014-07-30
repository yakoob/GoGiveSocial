component {

	public Log function init(){
		return this;
	}

	public void function logError(required any name, required any error, required any args, required any cgio){
		var uid = createuuid();
		var errorMessage = {};			
		errorMessage.error = arguments.error;
		errorMessage.cgi = arguments.cgio;
		errorMessage.arguments = arguments.args;			
		writedump(var=errorMessage,output="c:\ColdFusion9\logs\#arguments.name#_#uid#.html");	
	}
}
