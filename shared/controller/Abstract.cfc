/**
* @accessors true
* @extends shared.model.Object
*/
component{

	/**
    * @type struct
    */
    property reply;
    
	/** 
	* @type shared.model.error.Error
	*/
	property error;
	
	public Abstract function init(){	
		super.init();
		this.setError(application.context.ioc.getObjectInstance(class="shared.model.error.Error"));		
		reply = {};		
		return this;
	}
	
	public any function security(){
		var res = {};		
		var auth = invoke.Authentication();		
		res.security = {};
		
		if (!isnull(arguments.userId))
			res.security.hasWrite = auth.hasWrite(arguments.userId);
		return res;
	}
	
	public any function saveProcessData(required any args){		
		try {
			var dataSubmission = argumentsCleaner(args=arguments.args);						
			dataSubmission.objectCollection = processDataModel(dataSubmission);				
		}
		catch(any e){
			var dataSubmission = args;
			dataSubmission.objectCollection = e;
			this.getError().add("there was a system error while processing your data");
		}
		var res = event(						
			success = this.getError().has() ? false : true
		,	errors = this.getError().list()
		,	eventname= this.getError().has() ? 'error' : args.eventname
		, 	displaycontext=args.displaycontext
		, 	displaymethod=args.displaymethod
		, 	display=""					
		,	args=dataSubmission
		);		
		return res;
	}
	
	public any function argumentsCleaner(){
		return super.argumentsCleaner(argumentcollection=arguments);
	}

	private any function processDataModel(args){	
		arraysort(args.objectcollection,"textnocase", "desc");		
		var objects = args.objectcollection;
		var cnt = 0;
		var primaryObject = {};
		
		for (local.object in objects) {
			cnt = cnt + 1;
			var $tmpObject = replacenocase(replacenocase(replacenocase(object, "po:", "", "all"), "o:", "", "all"), "np:", "", "all");			
			evaluate("#$tmpObject# = invoke.#$tmpObject#()");
			evaluate("#$tmpObject# = structToObj(arguments.args.#$tmpObject#, #$tmpObject#)");			
			thisObj = evaluate("#$tmpObject#");			
			
			if ( findnocase("po:", object) ) {
				thisObj.validate();
				this.geterror().combine(thisObj.error().list());													
				primaryObject = thisObj;				
			}	

			else if ( findnocase("o:", object) ) {								
				
				if ( !this.geterror().has() ) {
	
					try {				
	
						thisObj.validate();
						this.geterror().combine(thisObj.error().list());	
																				
						if (!isnull(evaluate("primaryObject.#$tmpObject#()")))		
							evaluate("primaryObject.#$tmpObject#(thisObj)");
						else
							evaluate("primaryObject.add#$tmpObject#(thisObj)");															
					}
					catch(any e){						
						// fail
						this.geterror().combine(["an error occured working on #$tmpObject#"]);							
					}
				
				}
			}	
			
			else if ( findnocase("np:", object) ) {	
				try {					
					thisObj.validate();
					this.geterror().combine(thisObj.error().list());																					
					if ( !thisObj.error().has() ) {
						thisObj.save();	
					}
				}
				catch(any e){
					// fail					
				}
			}	
			
								
			
		}				
		if ( !this.getError().has() ) {											
			primaryObject = primaryObject.save();																						
		}
		return primaryObject;	
	}
			
	public struct function event(required string eventname, string display="", string displayContext="", string displayMethod="html", any data="", boolean success=true, struct args, errors=arraynew(1)){
		arguments.args.eventname = arguments.eventname;			
		arguments.args.display = arguments.display;
		arguments.args.displayContext = arguments.displayContext;
		arguments.args.displayMethod =  arguments.displayMethod;		
		arguments.args.data = arguments.data;
		arguments.args.success = arguments.success;	
		arguments.args.errors = arguments.errors;			
		return arguments.args;
	}

}		