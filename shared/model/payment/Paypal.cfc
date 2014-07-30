/**
* @accessors true
* @persistent true
* @extends shared.model.payment.Payment
* @table Payment
* @discriminatorValue Paypal
*/
component {

	/**
    * @type string
    */
    property account;
    
	public Paypal function init(){
		super.init();
		return this;
	}
}
