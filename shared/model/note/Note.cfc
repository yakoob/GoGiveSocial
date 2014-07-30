/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Note
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column noteId
	*/
	property id;
		
	/**
	* @type numeric
	*/	
	property userId;
	
	/**
	* @type numeric
	*/
	property accountId;
		
	/**
	* @type string
	*/	
	property note;
	
	/**
	* @type string
	*/	
	property username;

	/**
	* @type date
	*/
	property createdate;
			
	public Note function init(){
		super.init();
		return this;	
	}

}
