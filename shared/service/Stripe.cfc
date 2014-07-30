/**
* @output false
* @accessors true
* @extends shared.model.Object
*/
component {
	
	/**
	* @type string
	*/
	property key;
	
	/**
	* @type string
	*/
	property url;
	
	/**
	* @type string
	*/
	property urlPath;
	
	/**
	* @type string
	*/
	property body;
	
	/**
	* @type string
	*/
	property method;
					
	public Stripe function init(){
		super.init();					 	
		this.setKey("Basic #ToBase64("#request.stripe.api.testKey#")#"); // testing api key
		this.setUrl("https://api.stripe.com/v1/");
		return this;	
	}
	
	public any function create(required string card, required string month, required string year, string cvc="", required string amount, string currency="usd", string description = "test transaction"){	
		var res = {};		
		res.error = false;				
		
		try {
			res.token = getTokens(card=card,month=month,year=year,cvc=cvc,amount=amount,currency=currency);	
			if ( isJSON(res.token) )
				res.token = deserializejson(res.token);
			else
				res.token = {error = res.token};
			} catch(any e) {
			res.token = {error = "Token Service - Error"};
		}				
		if ( !structkeyexists(res.token, "error") ) {
			try {
				res.charge = getCharge(amount=res.token.amount, token=res.token.id, description=description );
				if ( isJSON(res.charge) )
					res.charge = deserializejson(res.charge);
				else
					res.charge = {error = res.charge};				
			} catch(any e){
				res.charge = {error = "Charge Service - Error"};
			}			
		}		
		if ( structkeyexists(res.token, "error") || structkeyexists(res.charge, "error")) {
			session.stripe = res;
			res.error = true;
		}
		else {
			StructDelete(session,"stripe");
		}			 
		return res;		
	}	
	
	/**
	* @hint working params card[number]=4242424242424242&card[exp_month]=12&card[exp_year]=2012&card[cvc]=123&amount=1000&currency=usd
	*/
	private any function getTokens(required string card, required string month, required string year, required string cvc, required string amount, string currency="usd"){
		this.setMethod("post");
		this.setUrlPath("tokens");		
		if (arguments.cvc != "") 
			this.setBody("card[number]=#arguments.card#&card[exp_month]=#arguments.month#&card[exp_year]=#arguments.year#&card[cvc]=#arguments.cvc#&amount=#arguments.amount#&currency=usd");
		else
			this.setBody("card[number]=#arguments.card#&card[exp_month]=#arguments.month#&card[exp_year]=#arguments.year#&amount=#arguments.amount#&currency=usd");		
		return post().getPrefix().filecontent.toString();		
	}
	
	/**
	* @hint working params amount=1000&currency=usd&card=tok_b89HGXEdlFKx7L&description=GoGiveSocial%20Donation%20for%20LA%20Mission2
	*/
	private any function getCharge(required string amount, required string token, string description="", string currency="usd"){
		this.setMethod("post");
		this.setUrlPath("charges");		
		this.setBody("amount=#amount#&currency=#currency#&card=#token#&description=#description#");			
		return post().getPrefix().filecontent.toString();		
	}
	
	private any function post(){
		var http = new http();				
   		http.setMethod(this.getMethod());   
   		http.setTimeout(240); 	    
		http.setUrl( getFullUrl() );		
		http.addParam(type="header", name="Accept-Charset", value="UTF-8");
		http.addParam(type="header", name="Authorization", value="#this.getKey()#");		
		http.addParam(type="header", name="Content-type", value="application/x-www-form-urlencoded");		
		http.addParam(type="body", value=this.getBody());		
		return http.send();
	}
		
	private string function getFullUrl(){
		return getURL() & getUrlPath();
	}

}




