/**
* @accessors true
* @persistent true
* @extends shared.model.payment.Payment
* @table Payment
* @discriminatorValue Ach
*/
component {

	/**
    * @type string
    */
    property account;
	
	/**
    * @type string
    */
    property routing;
    
	public Ach function init(){
		super.init();
		return this;
	}
}
