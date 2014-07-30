/**
* @output false
* @accessors true
* @extends shared.model.Object
*/
component {
	
	/**
	* @type string
	*/
	property server;

	/**
	* @type string
	*/
	property username;
	
	/**
	* @type string
	*/
	property password;
	
	/**
	* @type numeric
	*/
	property maxRows;
				
	public Pop3 function init(){
		super.init();		
		this.setServer("");
		this.setUsername("");
		this.setPassword("");
		this.setMaxRows(5);	
		return this;	
	}
	
	private any function list(){			
		try {
		    p = new pop();
		    p.setAttributes(server=this.getServer(),username=this.getUsername(),password=this.getPassword());		    	     	    	
		}
		catch(any e){
			writeoutput("I failed to make a pop3 connection");	
		}
	    return p.getHeaderOnly(maxRows=this.getMaxRows());
	}	
	
	private any function search(required string uid){		
		try {
		    p = new pop();
		    p.setAttributes(server=this.getServer(),username=this.getUsername(),password=this.getPassword()); 		    		     	    	
		}
		catch(any e){
			writeoutput("I failed to make a pop3 connection");	
		}	    
	    return p.GetAll(uid=arguments.uid,name="results",attachmentpath="c:\temp\#arguments.uid#");
	}
		
	private boolean function delete(required string uid){
		try {
			p = new pop();
			p.setAttributes(server=this.getServer(),username=this.getUsername(),password=this.getPassword()); 
			p.delete(uid=arguments.uid);
			return true;			
		}
		catch (any e){
			return false;			
		}		
	}
	
	public boolean function process(){				
		try {
			for(local.res in invoke.QueryUtils().queryToArray(list())){				
				var m = invoke.QueryUtils().queryToArray(search(uid=local.res["uid"]))[1];				
				var mc = invoke.EmailMessageContent();				
				mc.update_attributes(m);
				mc.save();
				delete(mc.uid());											
			}
		}
		catch(any e){
			writedump(e);
			return false;			
		}
		return true;
	}
		
}




