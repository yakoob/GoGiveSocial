/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
* @cfcommons:ioc:singleton
*/
component {

	public Authentication function init(){
		return this;
	}

		
	/**
	* @cfcommons:aop:advice:name isAuthenticated
	*/
	public any function isAuthenticated(){		
		return application.invoke.SessionManager().hasLogin();						
	}	
	
	public boolean function hasWrite(required numeric userId){
		if( isAuthenticated() ){
			if( arguments.userId == session.user.id() ){
				return true;
			}
		}
		return false;
	}
	
	public boolean function hasRead(){
		return true;
	}
	
	

	/*
	* @cfcommons:aop:advice:name hasAuthenticationToken
	
	public struct function hasAuthenticationToken(){				
		// authorization
		// eWFrb29iQGNvbGRmdXNpb25zb2NpYWwuY29tOmdhbWVzMDE=
	
		
		var e = application.ifn.ioc.getObjectInstance(class="org.apps.api.model.Errors");		
		import org.cfcommons.http.impl.*;
		var authFilter = new BasicAuthenticationFilter();
		var credentials = authFilter.getAuthenticationCredentials();
		if (!structkeyexists(credentials,"password")){			
			e.add("Security context is invalid...");
		}
															
		if (arraylen(e.list())){		
			throw(message=arraytolist(e.list()), type="Application", detail="arraytolist(e.list())", extendedInfo=arraytolist(e.list()));						
		}
		else {			
			return {halted="false",errors="",username=credentials.username, password=credentials.password};		
		}
		
		return true;				
	}
	*/		
	
}