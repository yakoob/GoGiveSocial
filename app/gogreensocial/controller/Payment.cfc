/**
* @cfcommons:mvc:controller
* @extends shared.controller.Payment
*/
component {

	public Payment function init(){
		super.init();
		return this;
	}
	
	/**	
	* @cfcommons:rest:uri /payment/cc/totals
	* @cfcommons:rest:httpMethod GET,POST	
	* @cfcommons:mvc:url /payment/cc/totals
	*/
	public any function getTotals(required string amount){		
		return super.getTotals(amount=arguments.amount);
	}	
	
	/**
	* @cfcommons:mvc:url /payment/cc
	* @cfcommons:rest:uri /payment/cc
	* @cfcommons:rest:httpMethod GET,POST
	* @event:broadcaster paymentMade
	*/
	public any function stripe(string card="4242424242424242",string month="12",string year="2012", string cvc="123", required string amount, string mode="live"){			
		if (isdefined("arguments.accountId"))
			arguments.description = "GoGreen | Account:#arguments.accountId# | General";
		else
			arguments.description = "GoGreen | General";			
		return super.stripe(argumentcollection=arguments);
	}		
	
	/**	
	* @cfcommons:rest:uri /payment/process/ledger
	* @cfcommons:rest:httpMethod GET,POST	
	* @event:listener paymentMade
	*/
	public any function processLedger(){		
		return super.processLedger(argumentcollection=arguments);
	}		
	
	/**
	* @cfcommons:mvc:url /account/{id:[0-9]*}/donate
	*/		
	public any function accountDonate(){
		super.accountDonate(argumentcollection=arguments);						
	}

	/** 
	* @cfcommons:mvc:url /ledger/donate
	*/
	public function ledgerDonate(){		
		super.ledgerDonate(argumentcollection=arguments);
	}

	/**	
	* @cfcommons:rest:uri /payment/method/{paymentMethod}
	* @cfcommons:rest:httpMethod GET,POST	
	*/
	public function displayPaymentMethod(){		
		return super.displayPaymentMethod(argumentcollection=arguments);			
	}

	/**
	* @cfcommons:mvc:url /donation/receipt
	*/
	public function donationReceipt(required numeric accountId, required numeric transactionId){
		super.donationReceipt(accountId=arguments.accountId, transactionId=arguments.transactionId);
	}
	
}