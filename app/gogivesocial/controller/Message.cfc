/**
* @accessors true
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
*/
component {
	
	public Message function init(){
		super.init();
		return this;
	}
	
	/**
	* @cfcommons:mvc:url /message/index
	*/		
	public function get() {		
		reply.messages = invoke.WebMessage().where({from=session.user.id()});
		view = '/view/message/message.cfm';
	}	

	/**
	* @cfcommons:mvc:url /message/new
	*/		
	public function form(numeric to=1) {			
		reply.to = arguments.to;
		view = '/view/message/new.cfm';
	}

	/**	
	* @cfcommons:rest:uri /message/save
	* @cfcommons:rest:httpMethod GET,POST	
	*/
	public any function saveMessage(){	
		var save = saveProcessData(arguments);		
		return save;					
	}
	
	
}

	
		