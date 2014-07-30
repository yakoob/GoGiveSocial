/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public function init(){
		return super.init();
	}


	/**	
	* @event:listener foooobarrrr
	* @event:broadcaster echo
	*/		
	public any function myBalls(){				
		arguments.myballs = true;
		arguments.account = invoke.user().search();
		
		writeDump(pubArgs(arguments));	
		return arguments;
		
	}	
	
	/**	
	* @event:listener echo
	*/	
	public any function iEcho(){	
		arguments.iecho = true;			
		writeDump(pubArgs(arguments));	
		
		abort;
		return arguments;
	}		
			
			
	/**
	* @cfcommons:rest:uri /asset/index
	* @cfcommons:rest:httpMethod GET
	*/
	public any function index(){	
		var res = {};
		res.page = "asset/index";
		res.foo = "bar";		
		return res;			
	}	

	/**
	* @cfcommons:rest:uri /asset/new/material/{ledgerId:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function addMaterial(){
		var ledger = invoke.ledger().findById(arguments.ledgerId);
		var m = invoke.Material();
		m.quantity(0);
		m.cost(0);
		m.isDonation(true);
		var newId = m.save().id();
		ledger.addAssets(m);			
		return newId;				
	}	
	
	/**
	* @cfcommons:rest:uri /asset/new/person/{ledgerId:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function addPerson(){
		var ledger = invoke.ledger().findById(arguments.ledgerId);
		var m = invoke.People();
		m.quantity(0);
		m.cost(0);
		m.isVolunteer(true);
		var newId = m.save().id();
		ledger.addAssets(m);				
		return newId;				
	}

	/**
	* @cfcommons:rest:uri /asset/new/place/{ledgerId:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function addPlace(){
		var ledger = invoke.ledger().findById(arguments.ledgerId);
		var m = invoke.Place();
		m.quantity(0);
		m.cost(0);
		m.isBooked(true);
		var newId = m.save().id();
		ledger.addAssets(m);					
		return newId;				
	}
	

	/**
	* @cfcommons:rest:uri /asset/save/{assetId:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function save(required string cost, required string name, required string date){		
		var m = invoke.asset().findById(arguments.assetId);
		m.quantity(arguments.quantity);
		m.cost(replace(arguments.cost, "$", ""));
		m.name(arguments.name);
		m.targetDate(arguments.date);
		m.save();					
		return true;						
	}	



	/**
	* @cfcommons:rest:uri /asset/delete/{assetId:[1-9][0-9]*}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public any function delete(){		
		var m = invoke.asset().findById(arguments.assetId);		
		m.delete();					
		return true;						
	}	


}
