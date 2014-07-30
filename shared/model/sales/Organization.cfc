/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Account
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column accountId
	*/
	property id;

	/**
	* @type string
	*/
	property type;
	
	/**
	* @type string
	*/
	property description;	
	
	/**
	* @type string
	* @default lead
	*/
	property status;
	
	/**
	* @type string
	*/
	property name;
	
	/**
	* @type date
	*/
	property createdate;
	
	/**
	* @type string
	*/
	property website;
	
	/**
	* @type string
	*/
	property createdBy;		
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.note.Note
	* @fkcolumn accountId
	* @cascade all
	*/	
	property note;		
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.email.EmailAddress
	* @fkcolumn accountId
	* @cascade all
	*/	
	property email;	
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.address.Address
	* @fkcolumn accountId
	* @cascade all
	*/	
	property address;
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.phone.WorkPhone
	* @fkcolumn accountId
	* @cascade all
	*/	
	property phone;	
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.person.Contact
	* @fkcolumn accountId
	* @sqltype integer
	* @cascade all
	*/	
	property contact;	

	public Organization function init(){		
		return this;
	}
	
	public boolean function validate(){		
		return true;		
	}
	
	
	
}
