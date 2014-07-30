import shared.model.util.*;
import shared.model.geoip.IpAddress;

/**
* @accessors true
* @extends shared.model.Object
*/
component {	
	
	/**
	* @type shared.model.util.Captcha	
	*/
	property captcha;	
		
	public SessionManager function init(){
		super.init();
		return this;
	}
	
	public void function startSession(any user=invoke.user()){		
		setUser(arguments.user);		
		setCaptcha(invoke.Captcha().generate());		
		setIpAddress();
		session.cart = {items=[],totals={}};
	}
	
	public void function addCart(numeric initiativeId=0, required string assetId, required string name, required string cost, required string quantity, required string assetType, required string donationType){
		if (!StructKeyExists(session,"cart"))
			session.cart = {items=[],totals={}};
		var res = {};
		res.assetId = arguments.assetId;
		res.name = arguments.name;
		res.cost = arguments.cost;		
		res.quantity = val(arguments.quantity) ? arguments.quantity : 1;		
		res.initiativeId = arguments.initiativeId;			
		if (arguments.assettype == 'place' && !val(arguments.cost)) {		
			res.cost = arguments.quantity;		
			res.quantity = 1;
		}
		
		res.assetType = arguments.assetType;	
		res.donationType = arguments.donationType;
		res.uid = createuuid();
		arrayappend(session.cart.items, res);
		setCartTotals();			
	}
	
	public void function removeCart(required string uid){		
		for (local.x=1; x<=arraylen(session.cart.items); x=x+1){
			if (isnumeric(arguments.uid)){			
				if (session.cart.items[x].assetid == arguments.uid)
					ArrayDeleteAt(session.cart.items, x);					
			}
			else {
				if (session.cart.items[x].uid == arguments.uid)
					ArrayDeleteAt(session.cart.items, x);					
			}	
		}
		setCartTotals();
	}

	public any function getCart(){	
		if (!StructKeyExists(session,"cart"))
			session.cart = {items=[],totals={}};			
		return session.cart;			
	}
	
	public any function setCartTotals(){		
		var res = {};
		var cost = 0;		
		for (local.x in getCart().items){
			if (x.donationtype == 'money')			
				cost = cost + ( x.cost * x.quantity );			
		}
		res.cost = cost;
		session.cart.totals = res;		
	}

	public void function clearCart(){
		structdelete(session, "cart");			
	}
	
	private void function setIpAddress(){
		session.ipAddress = application.invoke.IpAddress().ip(request.ip);			
	}
	
	public void function setCaptcha(required Captcha captcha){
		session.captcha = arguments.captcha;			
	}
	
	public void function setUser(required any user){
		session.user = arguments.user;		
	}
			
	private void function setCookie(numeric accountId=0, numeric userId=0){				
		getPageContext().getResponse().addHeader("Set-Cookie", "userId=#arguments.userId#; Max-Age=31622400");			
	}
	
	public void function logout(){
		structdelete(session, "user");		
		structdelete(session, "ipaddress");	
	}
	
	public boolean function hasLogin(){
		if (!StructKeyExists(session, "user")){
			setUser(invoke.user());
		}		
		if ( val(session.user.id()) )
			return true;
		return false;
	}

}
