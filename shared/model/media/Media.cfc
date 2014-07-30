/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Media
* @discriminatorColumn media_type
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column mediaId
	*/
	property id;

	/**
	* @type string
	*/
	property name;
	
	public Media function init(){		
		super.init();
		return this;
	}
	public any function getBinary(required string binary){
		return "binary";	
	}

	public any function convertBinary(required string binary){
		return "binary";	
	}
}
