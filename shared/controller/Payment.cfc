/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {

	public Payment function init(){
		super.init();
		return this;
	}
	

	public any function getTotals(required string amount){		
		if (val(arguments.amount)) {
			reply.amount = arguments.amount;			
			reply.fee = getFee(amount=arguments.amount);			
			reply.total = reply.amount + reply.fee;								
			view = '/view/payment/donation_totals.cfm';			
			return reply;	
		}
		else {
			view = '/view/none.cfm';	
			return "";	
		}		
	}
		
	private any function getFee(required string amount){	
		var fee = (arguments.amount * .05) + .35; 
		var feeMatrix = [];		
		var fm = {};	
		local.fm = {};		
		fm.min = 0;
		fm.max = 10;
		fm.fee = .07;		
		arrayappend(feeMatrix, fm);		
		local.fm = {};
		fm.min = 11;
		fm.max = 25;
		fm.fee = .065;	
		arrayappend(feeMatrix, fm);		
		local.fm = {};
		fm.min = 26;
		fm.max = 50;
		fm.fee = .06;		
		arrayappend(feeMatrix, fm);
		local.fm = {};
		fm.min = 51;
		fm.max = 100;
		fm.fee = .055;
		arrayappend(feeMatrix, fm);
		local.fm = {};
		fm.min = 101;
		fm.max = 200;
		fm.fee = .05;
		arrayappend(feeMatrix, fm);
		local.fm = {};
		fm.min = 201;
		fm.max = 300;
		fm.fee = .045;		
		arrayappend(feeMatrix, fm);
		local.fm = {};
		fm.min = 301;
		fm.max = 500;
		fm.fee = .04;		
		arrayappend(feeMatrix, fm);
		local.fm = {};
		fm.min = 501;
		fm.max = 1000000;
		fm.fee = .035;
		arrayappend(feeMatrix, fm);			
		
		for (local.x in feeMatrix){
			if (arguments.amount <= x.max && arguments.amount >= x.min) {
				fee = (amount * x.fee) + .35;							
			}
		}		
		return fee;
	}
	
	public any function stripe(required string card, required string month, required string year, required string cvc, required string amount, required string description, string mode="test"){		
		arguments = pubArgs(arguments);		
		var ourFee = getFee(arguments.amount);		
		ourFee = ourFee * 100;
		arguments.amount = amount*100;		
		arguments.amount = arguments.amount + ourFee;
		arguments.amount = round(arguments.amount);
		var stripe = invoke.Stripe();
		
		if(arguments.mode=="test")
			stripe.setKey("Basic #ToBase64("#request.stripe.api.testKey#")#");
		else
			stripe.setKey("Basic #ToBase64("#request.stripe.api.liveKey#")#");
	
		arguments.res = stripe.create(card=arguments.card,month=arguments.month,year=arguments.year,cvc=arguments.cvc,amount=arguments.amount, description=arguments.description);				
		if (len(trim(arguments.card)))
			arguments.card =  encrypt(arguments.card,invoke.CcUtils().getCcCryptoKey());
		
		var errors = [];		
		var t = invoke.TransactionLogCc();		
		var ip = invoke.IpAddress();
		ip.ip(request.ip);										
		// log GeoIp address
		try {
			ip.save();
		} catch(any e){
			//nozing
		}
		
		// save transaction
		try {
			arguments.ip = ip;			
			t.ipAddressId(arguments.ip.getId());
			t.createDate(now());
			t.transactionType("charge");
			t.save();			
		}
		catch (any e){
			// fail
		}
		
		/*
		* an error occured while processing credit card
		* log error transaction 
		*/	
		if (res.error) {			
			if (!isnull(res.token.error.message))
				arrayappend(errors, res.token.error.message);				
			t.hasError(true);
			if (!isnull(res.token.error.message))
				t.errorMessage(res.token.error.message);
			t.amount(amount);	
			try {
				t.save();				
			}
			catch (any e){
				// arguments.t.error = e;						
			}					
			return event(args=arguments, DISPLAYCONTEXT="", DISPLAYMETHOD="html", display="", eventname="error", errors=errors);			
		}
		
		/*
		* credit card sucessfully charged
		* log transaction
		*/
		try {
			if (!isnull(res.charge.amount))
				t.amount(res.charge.amount);			
			if (!isnull(res.charge.id))
				t.transactionId(res.charge.id);
			if (!isnull(res.charge.card.cvc_check))
				t.cvcCheck(res.charge.card.cvc_check);
			if (!isnull(res.charge.fee))
				t.fee(res.charge.fee);
			if (!isnull(res.charge.livemode))
				t.livemode(res.charge.livemode);
			if (!isnull(res.token.id))
				t.tokenId(res.token.id);
			t.save();	
			arguments.transactionId = t.id();					
		} catch (any e){
			// nothing
		}
		
		// log payment
		try {
			var payment = invoke.CreditCard();
			payment.transactionLogId(t.id());
			payment.name(URLDecode(arguments.creditcard_name));
			payment.amount(res.charge.amount);
			payment.fee(ourFee);
			payment.date(now());
			payment.bin(card);
			payment.experationMonth(month);
			payment.experationYear(year);			
			payment.cvv(cvv);			
			payment.save();					
		} catch (any e){
			// nothing
			// arguments.p.error = e;
		}				
	
		// Payment Plan / reoccuring donation
		if (!isnull(payment)){			
			try {				
				if (isdefined("arguments.gf")) {
					if (arguments.gf == "rd" ){
						var pp = invoke.PaymentPlan();
			 			pp.paymentId(payment.id());
						pp.createDate(dateformat(now(),'full' ));
						pp.frequency(arguments.gf_value);
						pp.setNextDate();
						pp.retryCount(0);
						pp.status("active");
						pp.save();
					}
				}
				
			} catch (any e) {				
				// paymentPlan failed
			}			
		}
		
		// get exsisitng account/user or create new and update session
		try {	
			var act = invoke.account().generateAccountByEmail(argumentcollection=arguments);			
			payment.userId(act.user()[1].id());
			payment.save();
			
		} catch (any e){
			// nothing
		}		
		return pubargs(event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="ccPaymentMade", errors=errors));
	}
	
	public any function processLedger(){		
		try {
			if (!arguments.res.error) {
				var sm = invoke.SessionManager();
				var cart = invoke.sessionmanager().getCart();			
				for (var item in cart.items){			
					if ( val(item.initiativeid) ){
						var initiative = invoke.Initiative().findById(item.initiativeid);
						var boon = invoke.LedgerBoon();
						boon.assetId(item.assetId);
						boon.quantity(item.quantity);		
						boon.personFk(session.user.id());
						initiative.ledger().addLedgerBoon(boon);						
					}	
				}		
				sm.clearCart();									
			}	
		} catch (any e){
			// not added
		}						
		return arguments;		
	}	

	public function accountDonate(){				
		var sm = invoke.SessionManager();		
		sm.clearCart();		
		reply.account = invoke.account().findById(arguments.id);		
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});	
		reply.formAction = '/donation/complete'; 
		reply.submitButton = 'Donation';
		reply.title = "#reply.account.name()# - Donation";		
		view = '/view/payment/donation_account.cfm';	
	}
	
	public function ledgerDonate(){
		var sm = invoke.SessionManager();
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});		
		reply.cart = invoke.sessionmanager().getCart();
		reply.submitButton = 'Payment|Volunteer';
		reply.title = ' - Confirm Donation | Volunteer';
		reply.hasLogin = sm.hasLogin();						
		reply.cart = sm.getCart();						
		if (!arraylen(reply.cart.items))
			location(url="/", addtoken="false" );
		for (var item in reply.cart.items){								
			if (!isnull(item.initiativeid) && val(item.initiativeid))
				var initiativeId = item.initiativeid;
				break;	
		}						
		if (!isnull(initiativeId)){
			reply.initiative = invoke.Initiative().findById(initiativeId);				
			reply.account = invoke.Account().findById(reply.initiative.accountId());	
		}	
		view = '/view/payment/confirmation_ledger.cfm';
	}
		
	public function donationReceipt(required numeric accountId, required numeric transactionId){
		reply.account = invoke.Account().findById(arguments.accountId);
		reply.payment = invoke.CreditCard().findOneTransactionLogId(arguments.transactionId);		
		view = '/view/payment/donation_receipt.cfm';
	}
	
	public function displayPaymentMethod(){		
		savecontent variable="displaycontent" {
			if (arguments.paymentMethod == "ach")
				include "/view/payment/method_ach.cfm";
			else
				include "/view/payment/method_creditcard.cfm";	
		};		
		return event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display=displaycontent, eventname="paymentMethodDisplayed");		
	}	
}