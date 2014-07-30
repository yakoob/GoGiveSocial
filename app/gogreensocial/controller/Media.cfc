/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public Media function init(){
		super.init();
		return this;
	}

	/**
	* @cfcommons:mvc:url /media/assets
	*/
	public function assets(){			
		view = '/view/media/assets.cfm';		
	}

	/**
	* @cfcommons:mvc:url /media/initiative
	*/
	public function initiative(){			
		view = '/view/media/initiative.cfm';		
	}
		
	/**
	* @cfcommons:mvc:url /media/api
	*/
	public function api(){			
		view = '/view/media/api.cfm';		
	}				
			
}
