/**
* @accessors true
* @extends shared.model.Object
*/
component {

	/**
	* @type string
	*/
	property loginId;
	
	/**
	* @type string
	*/
	property password;
	
	/**
	* @type string
	*/
	property cfid;
	
	/**
	* @type string
	*/
	property cftoken;

	/**
	* @type string
	*/
	property sessionid;

	/**
	* @type string
	*/
	property urltoken;

	public Login function init(){		
		return this;
	}
	
	public boolean function validate(){				
		var user = invoke.user();
		user.email(this.getLoginId());
		user.password(this.getPassword());										
		if ( user.isActive() ) {		
			user = invoke.user().findById(user.id());											
			invoke.SessionManager().startSession(user=user);			
			return true;				
		}																
		invoke.SessionManager().logout();
		return false;		
	}	
	
}
