/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {

	public Payment function init(){
		super.init();
		return this;
	}

	/**
	* @cfcommons:mvc:url /account/{id:[0-9]*}/donate
	*/		
	public any function accountDonate(){				
		reply.account = invoke.account().findById(arguments.id);		
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});	
		reply.formAction = '/donation/complete'; 
		reply.submitButton = 'Donation';
		reply.title = "#reply.account.name()# - Donation";				
		var sm = invoke.SessionManager();		
		sm.clearCart();
		sm.addCart(initiativeId=0, assetId = 0, name = "One-Time Donation", cost=100, quantity=1, assetType="na", donationType="money");		
		reply.cart = sm.getCart();			
		view = '/view/payment/donation_account.cfm';		
	}

	/** 
	* @cfcommons:mvc:url /payment/account
	*/
	public function diplayAccountPayment(required string accountType){
		
		reply.plan = arguments.accountType;
		
		reply.formAction = 'account/save'; 
		reply.submitButton = 'On to Step 2!';
		reply.title = 'Creating Your Account';		
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});	
		invoke.Captcha().generate();
		
		
		if (reply.plan == "premium"){
			view = '/view/account/new.cfm';		
		}
		else {

			var sm = invoke.SessionManager();		
			sm.clearCart();			
			if (reply.plan == "custom")
				sm.addCart(initiativeId=0, assetId = 0, name = "Account Plan (#reply.plan#)", cost=99, quantity=1, assetType="na", donationType="money");		
			if (reply.plan == "full")
				sm.addCart(initiativeId=0, assetId = 0, name = "Account Plan (#reply.plan#)", cost=35000, quantity=1, assetType="na", donationType="money");
			
			reply.cart = sm.getCart();			
			view = '/view/payment/account.cfm';					
		}
		
	}	

	/** 
	* @cfcommons:mvc:url /payment/ledger
	*/
	public function diplayLedgerPayment(){		
		var sm = invoke.SessionManager();
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});		
		reply.cart = invoke.sessionmanager().getCart();
		reply.submitButton = 'Payment|Volunteer';
		reply.title = ' - Confirm Donation | Volunteer';
		reply.hasLogin = sm.hasLogin();		
		if ( sm.hasLogin() ) {
			reply.user = session.user;
			if (!isnull(reply.user.accountId())){
				reply.account = invoke.Account().findById(reply.user.accountId());
			}
		}			
		reply.cart = sm.getCart();						
		for (var item in reply.cart.items){								
			if (!isnull(item.initiativeid) && val(item.initiativeid))
				var initiativeId = item.initiativeid;	
		}				
		if (!isnull(initiativeId)){
			reply.initiative = invoke.Initiative().findById(initiativeId);				
		}
		view = '/view/payment/confirmation_ledger.cfm';
	}



	/**	
	* @cfcommons:rest:uri /payment/method/{paymentMethod}
	* @cfcommons:rest:httpMethod GET,POST	
	*/
	public function displayPaymentMethod(){		
		savecontent variable="displaycontent" {
			if (arguments.paymentMethod == "ach")
				include "/view/payment/method_ach.cfm";
			else
				include "/view/payment/method_creditcard.cfm";	
		};		
		return event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display=displaycontent, eventname="paymentMethodDisplayed");		
	}
	
	/** 
	* @cfcommons:mvc:url /payment/ledger/process
	*/
	public function processLedgerPayment(){		
		var sm = invoke.SessionManager();		
		reply.cart = sm.getCart();		
		
		if (!arraylen(reply.cart.items))
			location(url="http://#request.app.url#", addtoken="false");
					
		if ( sm.hasLogin() ) {			
			var user = session.user;
			var account = invoke.account().findById(session.user.accountId());
		}			
		else {		
			var user = invoke.user().findByEmail(trim(arguments.email));
			if ( arraylen(user) ){				
				var user = user[1];	
				var account = invoke.account().findById(user.accountId());
			}
			else {				
				var account = invoke.account();
				account.type("contributor");
				account.status("active");
				account.name(arguments.firstname &  " " & arguments.lastname);							
				var user = invoke.user();
					user.email(arguments.email);
					user.password(randrange(1234,12312313));
					user.firstname(arguments.firstname);
					user.lastname(arguments.lastname);				
					account.addUser(user);							
				var address = invoke.address();
					address.type("billing");
					address.street(arguments.address_street);
					address.city(arguments.address_city);
					address.state(arguments.address_state);
					address.zipcode(arguments.address_zipcode);
					account.addAddress(address);				
				account.save();				
				var user = account.user()[1];			
			}						
		}
		
		// todo: create a proper individual contributor profile
		// set the contributer user session
		// sm.setUser(user);									
				
		for (var item in reply.cart.items){			
			var initiative = invoke.Initiative().findById(item.initiativeid);
			var boon = invoke.LedgerBoon();
			boon.assetId(item.assetId);
			boon.quantity(item.quantity);		
			boon.personFk(user.id());
			initiative.ledger().addLedgerBoon(boon);
			reply.initiativeId = initiative.id();	
		}						
		
		if ( !isnull(reply.cart.totals.cost) ){
			var paymentAmount = (reply.cart.totals.cost * .07) + reply.cart.totals.cost;			
		} 
				
		if ( StructKeyExists(arguments, "creditcard_name") ){
			var payment = invoke.CreditCard();
			payment.name(arguments.creditcard_name);
			payment.amount(paymentAmount);
			payment.date(now());
			payment.bin(arguments.creditcard_bin);
			payment.experation("#creditcard_expiration_month##creditcard_expiration_year#");
			payment.cvv(creditcard_cvv);			
		}
		else if ( StructKeyExists(arguments, "ach_name") ){
			var payment = invoke.Ach();
			payment.name(arguments.ach_name);
			payment.amount(paymentAmount);
			payment.date(now());
			payment.routing(arguments.ach_routing);
			payment.account(arguments.ach_account);								
		}
		if (!isnull(payment)){
			payment.userid(user.id());					
		}
		
		if(!isnull(reply.initiativeId)) {			
			reply.initiative = invoke.Initiative().findById(reply.initiativeId);
			reply.socialUrl = "http://#lcase(request.app.url)#/initiative/#reply.initiativeId#";
		}
		else {
			reply.socialUrl = "http://#lcase(request.app.url)#";
		}
								
		view = '/view/payment/donation_ledger_complete.cfm';		
		sm.clearCart();		
		
	}
	
	/** 
	* @cfcommons:mvc:url /payment/account/process
	*/
	public function processAccountPayment(numeric accountId=0){
					
		if ( val(arguments.accountId) )
			reply.org = invoke.account().findById(arguments.accountId);		
		
		var sm = invoke.SessionManager();		
		reply.cart = sm.getCart();		
		
		if (!arraylen(reply.cart.items))
			location(url="http://#request.app.url#", addtoken="false");
					
		if ( sm.hasLogin() ) {			
			var user = session.user;
			var account = invoke.account().findById(session.user.accountId());
		}			
		else {		
			var user = invoke.user().findByEmail(trim(arguments.email));
			if ( arraylen(user) ){				
				var user = user[1];	
				var account = invoke.account().findById(user.accountId());
			}
			else {				
				var account = invoke.account();
				account.type("contributor");
				account.status("active");
				account.name(arguments.firstname &  " " & arguments.lastname);							
				var user = invoke.user();
					user.email(arguments.email);
					user.password(randrange(1234,12312313));
					user.firstname(arguments.firstname);
					user.lastname(arguments.lastname);				
					account.addUser(user);							
				var address = invoke.address();
					address.type("billing");
					address.street(arguments.address_street);
					address.city(arguments.address_city);
					address.state(arguments.address_state);
					address.zipcode(arguments.address_zipcode);
					account.addAddress(address);				
				account.save();				
				var user = account.user()[1];			
			}						
		}
		
		if ( !isnull(reply.cart.totals.cost) ){
			var paymentAmount = (reply.cart.totals.cost * .07) + reply.cart.totals.cost;			
		} 
				
		if ( StructKeyExists(arguments, "creditcard_name") ){
			var payment = invoke.CreditCard();
			payment.name(arguments.creditcard_name);
			payment.amount(paymentAmount);
			payment.date(now());
			payment.bin(arguments.creditcard_bin);
			payment.experation("#creditcard_expiration_month##creditcard_expiration_year#");
			payment.cvv(creditcard_cvv);			
		}
		else if ( StructKeyExists(arguments, "ach_name") ){
			var payment = invoke.Ach();
			payment.name(arguments.ach_name);
			payment.amount(paymentAmount);
			payment.date(now());
			payment.routing(arguments.ach_routing);
			payment.account(arguments.ach_account);								
		}
		if (!isnull(payment)){
			payment.userid(user.id());					
		}						
											
		view = '/view/payment/donation_complete.cfm';		
		sm.clearCart();	
	}
		
	/**
	* @cfcommons:mvc:url /donation/complete
	*/
	public function donationComplete(){
		view = '/view/payment/donation_complete.cfm';
	}
	
}
