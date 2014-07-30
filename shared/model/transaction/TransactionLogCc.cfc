/**
* @accessors true
* @persistent true
* @extends shared.model.transaction.TransactionLog
* @table TransactionLog
* @discriminatorValue CreditCard
*/
component {

	/**
    * @type string
    */
    property cvcCheck;
	
	public TransactionLogCc function init(){
		super.init();
		return this;
	}
}
