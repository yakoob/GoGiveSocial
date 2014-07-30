/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Person
* @discriminatorColumn person_type
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column personId
	*/
	property id;

	/**
	* @type string
	*/
	property firstname;
	
	/**
	* @type string
	*/
	property lastname;
	
	/**
	* @type string
	*/
	property email;
	
	/**
	* @update false
	* @insert false
	* @sqltype integer
	* @column accountId
	*/
	property accountId;

	public Person function init(){		
		this.setError(application.context.ioc.getObjectInstance(class="shared.model.error.Error"));		
		return this;
	}
	
	public boolean function validate(){			
		
		if (!val(this.id())) {	
			if (!len(this.getFirstname()))
				this.getError().add("user requires firstname");
			if (!len(this.getLastname()))
				this.getError().add("user requires lastname");
			if (!len(this.getEmail()))
				this.getError().add("user requires email");
			if ( ( !findNoCase("@",this.getEmail()) || !findNoCase(".",this.getEmail()) ) && len(this.getEmail()) )
				this.getError().add("this is not a valid email address");					
			if (arraylen(where({email=this.getEmail()})))
				this.getError().add("email is already in use");
		}	
		return super.validate();
	
	}
	
}

