/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Account
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column accountId
	*/
	property id;

	/**
	* @type string
	*/
	property type;
	
	/**
	* @type string
	* @default pending
	*/
	property status;
	
	/**
	* @type string
	*/
	property name;
	
	/**
	* @type string
	*/
	property mission;

	/**
	* @type string
	*/
	property description;

	/**
	* @type string
	*/
	property website;
	
	/**
	* @type date
	*/
	property createdate;
	
	/**
	* @type date
	*/
	property createdBy;
		
	/**
	* @type string
	*/
	property verificationCode;
	
	/**
	* @type string
	*/
	property urlPath;

	/**
	* @type string
	*/
	property taxId;

	/**
	* @fieldtype one-to-many
	* @cfc shared.model.address.Address
	* @fkcolumn accountId
	* @cascade all
	*/	
	property address;
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.person.User
	* @fkcolumn accountId
	* @sqltype integer
	* @cascade all
	*/	
	property user;	

	/**
	* @type array
	* @fieldtype one-to-many
	* @cfc shared.model.initiative.Initiative
	* @fkcolumn accountId
	* @cascade all	
	*/	
	property initiatives;	
	
	/**
	* @type array
	* @fieldtype one-to-many
	* @cfc shared.model.blog.Blog
	* @fkcolumn accountId
	* @cascade all
	*/	
	property blogs;		
	
	public Account function init(){
		var uuid = createUuid();
		uuid = replace(uuid, "-", "", "all");
		this.setVerificationCode(uuid);		
		return this;
	}
	
	public boolean function validate(){
		if( !len(this.getName()) && this.getType() != 'individual' )
			this.getError().add("account requires a valid name");
		/*
		if( !len(this.getUrlPath()) )							
			this.getError().add("account creation requires a URL Path");
		if ( arraylen(invoke.account().findByUrlPath(this.getUrlPath())) )			
			this.getError().add("URL Path is already being used. Please select another name");
		*/			
		return super.validate();		
	}
	
	public string function getProfileImage(){
		return "/public/images/logo.png";
	}
	
	public array function getPartners(){				
		var partners = [];
		var ai = this.getInitiatives();		
		for (var x in ai) {			
			if ( arraylen(x.ledger().getVolunteers()) ){					
				for ( var y in x.ledger().getVolunteers()){								
					var has = false;
					for (var z in partners) {						
						if (z.id() == y.id())	
							has = true;						
					}	
					if (!has)
						arrayappend(partners, y);									
				}										
			}						
		}		
		return partners;	
	}

	public any function generateAccountByEmail(){
		var result = {};				
		var account = this;
		
		/*
		* make sure user attributes in arguments
		* converts the user form attributes to a user model object
		* if error occurs send a new account object back
		*/ 
		try {			
			var inUser = structToObj(argumentsCleaner(pubArgs(arguments)).user, invoke.User());
		}
		catch(any e){			
			return account;
		}					
		// check if address parameters are in the arguments
		try {
			var inAddress = structToObj(argumentsCleaner(pubArgs(arguments)).address, invoke.Address());			
		}
		catch(any e){			
			// no address found
		}		
		var sm = invoke.SessionManager();		
		if ( sm.hasLogin() ) {			
			var user = session.user;
			account = account.findById(session.user.accountId());
		}			
		
		if (!val(account.id())) {
			var user = invoke.user().findByEmail(trim(inUser.email()));
			if ( arraylen(user) ){				
				var user = user[1];	
				sm.startSession(user);	
				account = account.findById(user.accountId());
			}
			else {				
				account.type("contributor");
				account.status("active");
				if ( len(inUser.firstname()) && len(inUser.lastname()) )
					account.name(inUser.firstname() &  " " & inUser.lastname());	
				else
					account.name("unknown");
				var user = inUser;				
				user.password(randrange(1234,12312313));							
				account.addUser(user);				
				if (!isnull(inAddress)){
					var address = inAddress;
					address.type("billing");
					account.addAddress(address);					
				}				
				if ( len(user.email()) ) {
					account.save();			
					sm.startSession(invoke.User().findOneEmail(user.email()));	
				}								
			}
		}						
				
		return account;
	}
	
}
