/**
* @accessors true
* @persistent true
* @extends shared.model.person.Person
* @table Person
* @discriminatorValue contact
*/
component {
	
	/**
	* @type string
	*/
	property title;
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.phone.Phone
	* @fkcolumn personId
	* @cascade all
	*/
	property phone;	
	
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.email.ContactEmailAddress
	* @fkcolumn personId
	* @cascade all	
	* @lazy true
	*/
	property emails;		
					
	public Contact function init(){
		super.init();	
		return this;
	}
	
	public boolean function validate(){				
		return super.validate();
	}	

}