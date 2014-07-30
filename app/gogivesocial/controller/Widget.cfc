
/**
* @accessors true
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {
	
	public Widget function init(){
		super.init();
		return this;
	}

	/**
	* @cfcommons:mvc:url /widget/initiative/{id:[1-9][0-9]*}
	*/	
	public any function widgetInitiaitve(){	
		reply.initiative = invoke.initiative().findById(arguments.id);										
		var html = "";		
		savecontent variable="html" {				
			include "/view/widget/initiative.cfm";				
		};						
		html = serializejson(html);	
		var res = {};		
		var callback = arguments.callback;
		var jsonp = callback & "(" & html & ")";		
		writeoutput(jsonp);
		abort;	
	}
	
	
	/**
	* @cfcommons:mvc:url /widget/account/{urlPath:[a-zA-Z]{2,}}
	*/
	public any function widgetAccount(){	
		var account = application.invoke.account().findOneUrlPath(trim(urlPath));

		var html = "";		
		savecontent variable="html" {				
			include "/view/widget/account.cfm";				
		};						
		html = serializejson(html);	
		var res = {};		
		var callback = arguments.callback;
		var jsonp = callback & "(" & html & ")";		
		writeoutput(jsonp);		
		abort;
	}
		
	


}

	
		