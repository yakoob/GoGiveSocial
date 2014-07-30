component extends="app.Application" {
	this.name = "GoGiveSocial_v1";	
	this.datasource = "GoGiveSocial";
	this.sessionmanagement="yes";
	this.googlemapkey = "";
	request.facebook.api.key = "";
	request.linkedin.api.key = "";
	request.app.name = "GoGiveSocial";		
	request.datasource = this.datasource;

	request.mail.server = "smtp.gmail.com";
	request.mail.username = "website@gogivesocial.com";
	request.mail.password = "";
	request.mail.port = "";
	request.mail.ssl = true;
	

	
	if ( isDevelopment() )
		request.app.url = "local." & lcase(request.app.name) & ".com";
	else
		request.app.url = "www." & lcase(request.app.name) & ".com";

	public function onRequestStart() {				
		super.onRequestStart();	
	}
	
	public function onApplicationStart() {				
		// application constants
		super.onApplicationStart();				
	}	
	
	private boolean function isDevelopment(){		
		return false;
		if ( cgi.REMOTE_HOST == "127.0.0.1" )
			return true;
		if ( findnocase("192.168.20.", cgi.REMOTE_HOST) )
			return true;		
		return false;		
	}	


	public function onError(required any Exception, required string EventName){		
		if (!isDevelopment()){
			var args = {};
			savecontent variable="args" {				
				writedump(arguments);				
			}
			em = new shared.model.email.Email();
			em.to("support@coldfusionsocial.com");
			em.from("error@#request.app.url#");
			em.subject("#request.app.name# error");
			em.body(args);
			em.send();
		}
		
		if (!structkeyexists(arguments["Exception"], "Cause")) {
			if (isDevelopment()){
				writedump(arguments);
				abort;
			}				
			location(url="/error/index", addtoken="false" );
			abort;									
		}		
		if ( structkeyexists(arguments["Exception"]["Cause"], "Type") && arguments.Exception.Cause.Type == "MVCURLMappingNotFoundException"){
			location(url="/404/index?urlPath=#cgi.path_info#", addtoken="false" );
			abort;				
		}
		else {
			if (isDevelopment()){
				writedump(arguments);
				abort;
			}				
			location(url="/error/index", addtoken="false" );
			abort;	
		}			
	}	

}