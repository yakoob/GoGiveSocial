/**
* @accessors true
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {	
	
	public Email function init(){
		super.init();
		return this;
	}

	public function index() {		
		view = '/view/email/index.cfm';
	}

	/**
	* @cfcommons:mvc:url /email/verify
	*/
	public function verify() {	
		
		reply.user = invoke.person().findById(session.user.id());
		
		if (val(reply.user.accountId())) {
			session.user = reply.user;
			reply.account = invoke.account().findById(reply.user.accountId());				
			var email = invoke.email();					
			email.to(reply.user.email());
			email.from("support@#invoke.String().baseUrl(request.app.url)#");
			email.subject("#request.app.name# - Email Verification");
			email.body("			
				Hi #reply.user.firstname()#,<br><br>		
				<p>Your #request.app.url# account has been created.</p>
				<p>Please visit http://#request.app.url#/email/verify/#reply.account.verificationCode()# to verify this is your email address, making your account active.</p>			
				Username:  	#reply.user.email()#<br>
				Password:  	#reply.user.password()#<br>
				Account Number:  	#reply.account.id()#<br>
				Please save this email with your important account information.
				<br><br>							
				#request.app.name#<br>
				support@#invoke.String().baseUrl(request.app.url)#
				");
			email.send();							
		}
		else {
			writeoutput("there was an error... Please contact support@#invoke.String().baseUrl(request.app.url)#");
			
		}	
		view = '/view/email/verify.cfm';	
	}
	
	/**
	* @cfcommons:mvc:url /email/verify/{verificationCode}
	*/	
	public function confirmation(){
		var account = invoke.account().findOneVerificationCode(arguments.verificationCode);
		session.user = account.user()[1];
		location(url='/account/index', addtoken="false");
		abort;		
	}

}

	
		