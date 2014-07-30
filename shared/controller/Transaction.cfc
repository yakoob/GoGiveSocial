/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {

	public Transaction function init(){
		super.init();
		return this;
	}

	
	/**
	* @cfcommons:mvc:url /payment/cc
	* @cfcommons:rest:uri /payment/cc
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function log(string card="4242424242424242",string month="12",string year="2012", string cvc="123", required string amount, required string description){			
		arguments.res = invoke.Stripe().create(card=arguments.card,month=arguments.month,year=arguments.year,cvc=arguments.cvc,amount=arguments.amount, description=arguments.description);				
		var errors = [];
		if (res.error) {
			arrayappend(errors, res.token.error.message);
			return pubargs(event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="error", errors=errors));			
		}
			
		return pubargs(event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="ccPaymentMade", errors=errors));
	}	

}