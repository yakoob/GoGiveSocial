/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public Company function init(){
		super.init();
		return this;
	}
	
	/**	
	* @event:listener blogAdded
	*/		
	public any function notifyOwner(){
		arguments.notifyOwner = true;	
		writeDump(pubArgs(arguments));	
		return arguments;
		
	}	
	
				
}
