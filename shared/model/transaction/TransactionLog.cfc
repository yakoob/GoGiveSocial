/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table TransactionLog
* @discriminatorColumn method
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column transactionLogId
	*/
	property id;

	/**
    * @type string
    */
    property transactionType;
    
	/**
    * @type string
    */
    property transactionId;          
    
    /**
    * @type string
	*/
	property ipAddressId;
	
    /**
	* @type boolean
	*/
	property livemode;
	
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
    property currency;
    
    /**
	* @type boolean
	*/
	property hasError;
	
	/**
	* @type string
	*/
	property errorMessage;
	
	/**
	* @type date
	*/
	property createdate;
	
	public TransactionLog function init(){
		super.init();
		return this;
	}
}
