/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public function init(){
		super.init();
		return this;
	}
	
	public function index(string urlPath=""){		
		reply.urlPath = arguments.urlPath;
		view = '/view/404.cfm';			
	}	
	
			
}
