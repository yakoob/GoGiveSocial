/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public Home function init(){
		super.init();
		return this;
	}
	
	public function defaultUrl(){	
		if (structKeyExists(session,"user") && val(session.user.id()) && val(session.user.accountId())) {
			reply.account = invoke.account().findById(session.user.accountId());													
			reply.partners = []; //reply.account.partners();
			view = '/view/account/private_profile.cfm';
		}		
		else {
			var blog = invoke.HomeBlog();			
			reply.blogs = blog.search();				
			reply.initiatives = invoke.Initiative().search();					
			view = '/view/home/index.cfm';
		}
	}
	
	public function redirect(required string url){
		var uri = "/" & arguments.url;
		uri = replace(uri, ".json", "");		
		location(url=uri, addtoken=false);
		abort;		
	}	
			
	public function captcha(){
		invoke.Captcha().generate();
		view = '/view/util/captcha.cfm';
	}	

	public function contact(){
		view = '/view/home/contact.cfm';
	}
		
	public function privacy(){
		view = '/view/home/privacy.cfm';
	}		
		
	public function terms(){		
		view = '/view/home/terms.cfm';
	}	
}