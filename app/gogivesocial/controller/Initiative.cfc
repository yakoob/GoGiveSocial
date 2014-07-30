/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public function init(){		
		return super.init();		
	}		
		
	/**	
	* @cfcommons:mvc:url /initiative/{id:[1-9][0-9]*}
	* @cfcommons:rest:uri /initiative/{id:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/		
	public any function initiative(){		
		
		reply.initiative = invoke.initiative().findById(arguments.id);		
		if (!val(reply.initiative.id())) {
			writeDump("no such inititaive");
			abort;			
		}				
		reply.security = security(userId=reply.initiative.userId()).security;
		reply.formAction = ''; 
		reply.submitButton = 'Add Features';
		reply.hasLedgerDraft = false;
		reply.title = '';		
		
		// todo: add aop to context and use preaspect for permission		
		if ( reply.security.hasWrite )
			reply.hasLedgerDraft = true;	
		
		if (val(session.user.id()))
			view = '/view/initiative/index_secure.cfm';					
		else
			view = '/view/initiative/index.cfm';
		return reply;			
	}
	
	/**
	* @cfcommons:mvc:url /initiative/features
	*/		
	public function assets(){
		reply.formAction = 'blahh'; 
		reply.submitButton = 'Add Features';
		reply.title = 'Adding Initiative features';
		view = '/view/initiative/features.cfm';
	}

	/**
	* @cfcommons:mvc:url /initiative/partial
	* @cfcommons:rest:httpMethod GET,POST	
	*/		
	public function partial(string searchString=""){
		var keys = arraynew(1);
		arrayappend(keys, "name");
		arrayappend(keys, "summary");
		arrayappend(keys, "issue");
		arrayappend(keys, "solution");
		arrayappend(keys, "message");
		reply.initiatives = invoke.Initiative().like(keys,arguments.searchString);		
		view = "/view/initiative/partial_list.cfm";		
	}
		

	/**
	* @cfcommons:mvc:url /initiatives/search
	*/		
	public function initiatives(){
		reply.initiatives = invoke.Initiative().search();
		view = '/view/initiative/initiatives.cfm';
	}
	
	/**
	* @cfcommons:mvc:url /myinitiative/{userId:[1-9][0-9]*}
	*/		
	public function myInitiative(){
		reply.initiatives = invoke.Initiative().where({userId=session.user.id()});
		view = '/view/initiative/my_initiatives.cfm';
	}

	/**
	* @cfcommons:mvc:url /initiative/find
	* @cfcommons:rest:httpMethod GET,POST	
	*/	
	public function find(string searchString=""){
		var keys = arraynew(1);
		arrayappend(keys, "name");
		arrayappend(keys, "summary");
		arrayappend(keys, "issue");
		arrayappend(keys, "solution");
		arrayappend(keys, "message");			
		reply.initiatives = invoke.Initiative().like(keys,arguments.searchString);
		view = '/view/initiative/find.cfm';	
	}			

	/**	
	* @cfcommons:aop:before:advice isAuthenticated
	* @cfcommons:mvc:url /initiative/new
	*/
	public function newInitiative(){					
		view = "/view/initiative/new.cfm";		
	}	

	/**	
	* @cfcommons:rest:uri /initiative/save
	* @cfcommons:rest:httpMethod GET,POST	
	*/
	public any function saveInitiative(){			
		arguments["po:initiative[status]"] = "active";
		arguments["po:initiative[accountId]"] = session.user.accountId();				
		arguments["o:user[ID]"] = session.user.id();				
		var save = saveProcessData(arguments);
		return save;					
	}

	/**	
	* @cfcommons:mvc:url /initiative/{id:[1-9][0-9]*}/images
	*/
	public function initiativeImages(){
		var dir = request.app.asset & "initiative\" & arguments.id & "\";		
		reply.images = [];		
		try {
			reply.images = directoryList(dir);	
		}
		catch (any e) {
			invoke.Upload().createDirectory(dir);		
		}				
		reply.id = arguments.id;	
		view = "/view/initiative/images.cfm";		
	}	

	/**	
	* @cfcommons:mvc:url /initiative/image
	*/
	public function initiativeImage(required string image){
		var i = request.app.asset & "initiative\" & arguments.id & "\" & arguments.image;		
		reply.image = i;		
		view = "/view/initiative/image.cfm";		
	}

	/**
	* @cfcommons:mvc:url /initiative/{id:[1-9][0-9]*}/ledger
	*/		
	public function ledger(){		
		reply.initiative = invoke.initiative().findById(arguments.id);		
		reply.formAction = "";	
		reply.submitButton = "";
		reply.title = 'add ledger assets';
		var sm = invoke.SessionManager();		
		sm.clearCart();			
		reply.cart = sm.getCart();		
		view = '/view/initiative/ledger.cfm';
	}
		
	/**
	* @cfcommons:mvc:url /initiative/{id:[1-9][0-9]*}/ledger/draft
	*/		
	public function ledgerDraft(){
	
		reply.initiative = invoke.initiative().findById(arguments.id);		
		// todo: begin: add aop to context and use preaspect for permission
		var canEdit = false;
		if (session.user.id() == reply.initiative.user().id()){
			reply.hasLedgerDraft = true;	
			var canEdit = true;	
		}	
		if (!canEdit) {		
			writeDump("you do not have permission to this resource");
			abort;									
		}
		// todo: end: add aop to context and use preaspect for permission
		reply.formAction = ''; 		
		reply.geoIP = invoke.IpAddress().ip(cgi.REMOTE_ADDR);
		reply.region = invoke.CountryRegion().where({CountryID=reply.geoIP.region().countryID(),size=1000,sort="name",direction="asc",isActive=1});	
		reply.submitButton = 'Draft Ledger';
		reply.title = 'Create #reply.initiative.name()# Ledger';
		reply.cart = invoke.sessionmanager().getCart();
		
		view = '/view/initiative/ledger_draft.cfm';
	}
	
	
	/**
	* @cfcommons:mvc:url /ledger/cart
	*/
	public any function ledgerCart(){
		reply.cart = invoke.SessionManager().getCart();
		view = '/view/initiative/cart.cfm';
	}

	/**
	* @cfcommons:mvc:url /ledger/cart/add
	* @cfcommons:rest:uri /ledger/cart/add
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function ledgerCartAdd(numeric initiativeId="0", required string assetId, required string quantity, required string type, string DISPLAYMETHOD="", string DISPLAYCONTEXT="", numeric amount=0){
		var amt = arguments.amount;
		var asset = invoke.Asset().findbyId(arguments.assetId);
		if (!val(amt))
			amt = asset.cost();			
		invoke.sessionmanager().addCart(initiativeId=arguments.initiativeId,assetId=asset.id(),name=asset.name(),cost=amt,quantity=arguments.quantity,assetType=listlast(getmetadata(asset).name,"."),donationType=arguments.type);
		reply.cart = invoke.sessionmanager().getCart();
		view = '/view/initiative/cart.cfm';
		return event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display="", eventname="cartUpdated");				
	}


	/**
	* @cfcommons:mvc:url /ledger/cart/remove
	*/
	public any function ledgerCartRemove(uid=arguments.uid){		
		invoke.sessionmanager().removeCart(uid=arguments.uid);
		reply.cart = invoke.sessionmanager().getCart();
		view = '/view/initiative/cart.cfm';
	}	

	/**
	* @cfcommons:mvc:url /ledger/cart/clear
	*/
	public any function ledgerClearCart(){
		invoke.sessionmanager().clearCart();
		abort;
	}	

}