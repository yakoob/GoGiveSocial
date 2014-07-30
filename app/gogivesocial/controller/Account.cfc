import org.cfcommons.reflection.impl.*;

/**
* @accessors true
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {
	
	public Account function init(){
		super.init();
		return this;
	}

	public function index() {		
		
		if ( val(session.user.accountId()) ){						
			var account = application.invoke.account().findById(session.user.accountId());
			reply.account = account;		
			reply.partners = account.getPartners();					
			view = '/view/account/private_profile.cfm';
		}
		else {
			var blog = invoke.HomeBlog();		
			reply.blogs = blog.search();
			reply.initiatives = invoke.Initiative().search();				
			view = '/view/home/index.cfm';
		}					
	}

	/**
	* @cfcommons:mvc:url /{urlPath:[a-zA-Z]{2,}}
	*/
	public any function accountPublic(){	
		var account = application.invoke.account().findOneUrlPath(trim(urlPath));
		reply.account = account;		
		reply.partners = account.getPartners();			
		if (val(reply.account.id()))
			view = '/view/account/public_profile.cfm';
		else
			view = '/view/404.cfm';
	}
	
	/**
	* @cfcommons:mvc:url /featured/nonprofit
	*/		
	public function featuredNonprofit() {	
		reply.account = invoke.account().where({type="Organization"});		
		if (arraylen(reply.account)){
			reply.account = reply.account[randrange(1,arraylen(reply.account))];	
			view = '/view/account/organization_featured.cfm';
		}
		else {
			writeoutput("no organizations found...");
			abort;
		}
		
		
	}

	/**
	* @cfcommons:mvc:url /account/profile
	*/		
	public function profile() {	
		reply.account = invoke.account().findById(session.user.accountId());		
		reply.initiatives = invoke.Initiative().search();			
		view = '/view/account/index.cfm';
	}

	/**
	* @cfcommons:mvc:url /account/new
	*/		
	public function accountNew(){			
		reply.formAction = 'account/save'; 
		reply.submitButton = 'On to Step 2!';
		reply.title = 'Creating Your Account';		
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});	
		invoke.Captcha().generate();
		view = '/view/account/new.cfm';
	}

	/**
	* @cfcommons:mvc:url /account/update
	*/		
	public function accountUpdate(){
		reply.account = invoke.account().findById(session.user.accountId());		
		reply.formAction = 'account/save'; 
		reply.submitButton = 'Update My Profile';
		reply.title = 'Creating Your Account';		
		reply.geoIP = invoke.IpAddress().ip(request.ip);		
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc"});	
		invoke.Captcha().generate();		
		view = '/view/account/update.cfm';
	}
	
	/**
	* @event:broadcaster accountCreated
	* @cfcommons:rest:uri /account/save
	* @cfcommons:rest:httpMethod GET,POST	
	*/		
	public any function accountSave(){
		try{
			var up = arguments["po:account[name]"];		
			up = replace(up, " ", "", "all");
			up = replace(up, "'", "", "all");
			up = replace(up, "%", "", "all");								
			up = ReReplaceNoCase(up,"[0-9]", "", "all");					
			arguments["po:account[urlPath]"] = up;					
		}
		catch (any e) {
			// no base path
		}	
		return pubargs(saveProcessData(arguments));				
	}

	/**
	* @event:listener accountCreated	
	*/
	public any function startAccountSession(){						
		invoke.SessionManager().startSession(account=arguments.mainInvocation.objectcollection,user=arguments.mainInvocation.objectcollection.user()[1]);		
		return arguments;
	}

	/**	
	* @cfcommons:rest:uri /account/type/{accountType}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public function displayAccountType(){		
		savecontent variable="displaycontent" {
			include "/view/account/type_#arguments.accountType#.cfm";						
		};		
		return event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display=displaycontent, eventname="paymentMethodDisplayed");		
	}

	/**
	* @cfcommons:mvc:url /account/messages
	*/		
	public function listMessages() {	
		view = '/view/account/messages.cfm';
	}
	
	/**
	* @cfcommons:mvc:url /account/events
	*/		
	public function listEvents() {	
		view = '/view/account/events.cfm';
	}	
	
	/**
	* @cfcommons:mvc:url /account/friends
	*/		
	public function listFriends() {	
		view = '/view/account/friends.cfm';
	}		
	
	/**
	* @cfcommons:mvc:url /account/login
	* @cfcommons:rest:uri /account/login
	* @cfcommons:rest:httpMethod POST,GET
	*/
	public function login(){		
		reply.formAction = 'insertAccount'; 
		reply.submitButton = 'On to Step 2!';
		reply.title = 'Creating Your Account';				
		view = '/view/account/login.cfm';		
		try {		
			var login = invoke.Login();
			login.loginId(arguments["LOGIN[EMAIL]"]);
			login.password(arguments["LOGIN[PASSWORD]"]);
			if ( login.validate() )
				var res = event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="loginPassed");			
			else				
				var res = event(errors=['login failed'], args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="error");												
		}		
		catch(any e) {			
			var res = event(errors=['Login is unavailable at the moment.  Please try again later...'], args=arguments, DISPLAYCONTEXT="page", DISPLAYMETHOD="", display="", eventname="error");		
		}		
		return res;
	}	

	/**
	* @cfcommons:mvc:url /account/logout
	* @cfcommons:rest:uri /account/logout
	* @cfcommons:rest:httpMethod POST,GET
	*/
	public boolean function logout(){			
		invoke.SessionManager().logout();			
		view = '/view/account/logout.cfm';
		return true;
	}

}

	
		