/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table PaymentPlan
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column paymentPlanId
	*/
	property id;
	
	/**
	* @type numeric
	*/
	property paymentId;
	
	/**
	* @type string
	*/
	property frequency;
	
	/**
    * @type date
    */
    property createDate;	
	
	/**
    * @type date
    */
    property nextDate;

	/**
    * @type date
    */
    property retryDate;
	
	/**
    * @type numeric
    */
    property retryCount;	
	
	/**
    * @type date
    */
    property endDate;
    
	/**	
	* @type shared.model.payment.Payment
	* @fieldtype many-to-one
	* @cfc shared.model.payment.Payment
	* @fkcolumn paymentId
	* @update false
	* @insert false
	*/	
	property payment;	 
    
	public PaymentPlan function init(){
		super.init();
		return this;
	}
	
	public void function setNextDate(){
		
		if (!isnull(this.getFrequency())){
			
			if (this.getFrequency() == "annually") {
				variables.nextDate = dateadd("yyyy",+1,now());	
			}

			if (this.getFrequency() == "monthly") {
				variables.nextDate = dateadd("m",+1,now());
			}			
				
			
		}
		
		
	}
}
