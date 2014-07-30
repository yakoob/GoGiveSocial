/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Address
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column addressId
	*/
	property id;
	
	/**
    * @type string
    */
    property type;
		
	/**
    * @type string
    */
    property street;
	
	/**
	* @type string
	*/
	property city;
	
	/**
    * @type string
    */
    property state;
	
	/**
    * @type string
    */
    property zipcode;
    
	public Address function init(){		
		return this;
	}
	
	public boolean function validate(){			
		if (!len(this.getStreet()))
			this.getError().add("address requires a Street");
		if (!len(this.getCity()))
			this.getError().add("address requires a City");
		if (!len(this.getState()))
			this.getError().add("address requires a State");
		if (!len(this.getZipcode()))
			this.getError().add("address requires a Zipcode");		
		return super.validate();
	}	
}
