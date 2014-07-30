/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public Seo function init(){
		super.init();
		return this;
	}
	
	/**
	* @cfcommons:mvc:url /[0-9A-Za-z-]*(\.html)$
	*/		
	public function seo(){
		var scriptName=invoke.Utility().cleanScriptName();
		var res = invoke.seoPage().where({page=invoke.Utility().cleanScriptName()});															
		if (!arraylen(res)) {
			view = '/view/404.cfm';
		}				
		else {						
			reply.seoPage = res[1];
			reply.seoPageContent = invoke.seoPageContent().where({seoPageId=reply.seoPage.id(), sort="id", direction="asc"});				
			view = '/view/seo/page.cfm';
		}
	}			

	/**
	* @cfcommons:mvc:url /sitemap/index
	*/
	public function sitemap(){
		reply.sitemap = getPages();		
		view = '/view/home/sitemap.cfm';		
	}
	
	/**
	* @cfcommons:mvc:url /googlesitemap/index
	*/
	public function googlesitemap(){
		reply.sitemap = getPages();											
		view = '/view/seo/googlesitemap.cfm';		
	}	
	
	private any function getPages(){
		var sitemap = invoke.seoPage().search();			
		var i = invoke.initiative();
		i.setSize(100000);		
		for (var x in i.search()){
			var sm = invoke.seoPage();
			sm.setPage("initiative/#x.id()#");
			sm.setTitle(x.name());
			sm.setDescription(x.summary());
			sm.setKeywords("socialfunding, social fundraising, online fundraising");			
			arrayappend(sitemap, sm);
		}						
		return sitemap;
	}	
	
			
}
