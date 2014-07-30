/**
* @cfcommons:mvc:controller
* @extends shared.model.security.Authentication
* @accessors true
* @cfcommons:ioc:singleton
*/
component {
	
	public Authentication function init(){
		super.init();
		return this;
	}	
	
	public any function hasLogin(){
		return super.isAuthenticated();		
	}

	/**	
	* @cfcommons:aop:advice:name isAuthenticated
	*/	
	public any function isAuthenticated(){		
		if ( !super.isAuthenticated() )
			location('/validate/authentication');					
		return arguments;				
	}
		
	/**	
	* @cfcommons:aop:advice:name hasWrite
	*/	
	public boolean function hasWrite(required numeric userId){		
		arguments["hasWrite"]=super.hasWrite(userId=arguments.userId);
		return arguments;
	}	

	/**
	* @cfcommons:mvc:url /validate/authentication
	* @cfcommons:rest:uri /validate/authentication
	* @cfcommons:rest:httpMethod POST,GET
	*/
	public boolean function displayAuthenticate(){	
		view = '/view/account/authenticate.cfm';		
		return true;
	}	



}