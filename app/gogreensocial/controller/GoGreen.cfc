/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public GoGreen function init(){
		reply.formAction = 'blahh'; 
		reply.submitButton = 'Add Features';
		reply.title = 'Adding Initiative features';
		view = '/view/initiative/features.cfm';	
		return this;
	}
	
	public function index(){		
	}

			
}
