/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Phone
* @discriminatorColumn phone_type
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column phoneId
	*/
	property id;
	
	/**
	* @type string
	*/	
	property number;
	
	public Phone function init(){
		super.init();
		return this;	
	}

}
