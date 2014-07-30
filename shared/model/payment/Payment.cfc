/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Payment
* @discriminatorColumn method
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column paymentId
	*/
	property id;
	
	/**
	* @type numeric
	*/
	property transactionLogId;
	
	/**
    * @type date
    */
    property date;
	
	/**
    * @type numeric
    */
    property amount;
    
    /**
    * @type numeric
    */
    property fee;
    
    /**
	* @type string
	*/
	property name;
	
	/**
	* @type numeric
	*/
	property userId;
    
	public Payment function init(){
		super.init();
		return this;
	}
}
