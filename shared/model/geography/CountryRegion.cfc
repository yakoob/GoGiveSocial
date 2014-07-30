/**
* @persistent true
* @accessors true
* @extends shared.model.Object
*/
component {
	
	/**
	* @type numeric
	* @persistent true
	* @fieldtype id
	* @ormtype integer
	* @generator native
	* @column id
	*/
	property id;
	
	/**
    * @type numeric
	* @default 221
    */
    property countryID;
	
	/**
    * @type string
    */
    property iso;
	
	/**
    * @type string
    */
    property code;
	
	/**
    * @type string
    */
    property name;
	
	/**
    * @type boolean
	* @default 1
    */
    property isActive;
		
	public countryRegion function init(){		
		return this;
	}
}