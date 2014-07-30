/**
* @accessors true
* @persistent true
* @extends shared.model.person.Person
* @table Person
* @discriminatorValue user
*/
component {
	
	/**
	* @type string
	*/
	property password;

	/**
	* @type string
	* @persistent false
	*/
	property verifyPassword;
	
	public User function init(){
		super.init();	
		return this;
	}
		
	public boolean function isActive(){		
		var user = where({email=this.getEmail(),password=this.getPassword()});						
		if (val(arraylen(user))) {		
			this.setid(user[1].id());
			return true;
		}					
		return false;
	}
	
	public boolean function validate(){			
		super.validate();
		if (!val(this.id())){		
			if (!len(this.getPassword()))
				this.getError().add("user requires password");	
			if (this.getPassword() != this.getVerifyPassword())	
				this.getError().add("your password verification does not match");
		}				
		return super.validate();
	}	

}