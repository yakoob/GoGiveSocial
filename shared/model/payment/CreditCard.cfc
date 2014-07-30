/**
* @accessors true
* @persistent true
* @extends shared.model.payment.Payment
* @table Payment
* @discriminatorValue CreditCard
*/
component {

	/**
    * @type string
    */
    property bin;
	
	/**
    * @type string
    */
    property experationMonth;	
	
	/**
	* @type string
	*/
	property experationYear;
	
	/**
    * @type string
    */
    property cvv;
	
	public CreditCard function init(){
		super.init();
		return this;
	}
	
	public void function decryptBin(){		
		this.setBin(decrypt(this.getBin(), invoke.CcUtils().getCcCryptoKey()));
	}

	
	
}
