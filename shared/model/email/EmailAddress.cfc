/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table EmailAddress
* @discriminatorColumn type
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column emailAddressId
	*/
	property id;
	
	/**
	* @type string
	*/
	property emailAddress;
	

	public EmailAddress function init(){			
		return this;
	}
	
	public boolean function validate(){				
		return super.validate();		
	}
	
}
