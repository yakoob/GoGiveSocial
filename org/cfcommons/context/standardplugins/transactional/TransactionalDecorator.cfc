import org.cfcommons.context.*;
import org.cfcommons.transactional.impl.*;

component accessors="true" implements="org.cfcommons.context.ObjectDecorator" {
	property Context context;
	property TransactionalService transactionalService;
	
	public TransactionalDecorator function init(){
		setTransactionalService(new TransactionalService());
		return this;
	}
	
	public any function decorate(required any object, required string className){
		var class = variables.context.getClass(arguments.className);
		var transactionalMethods = class.getMethodsAnnotatedAs("cfcommons:transactional");
		
		var transactionalMethodNames = [];
		for(var i = 1; i <= arrayLen(transactionalMethods); i++){
			arrayAppend(transactionalMethodNames, transactionalMethods[i].getName()); 
		}		
		
		return getTransactionalService().makeTransactional(arguments.object, transactionalMethodNames);
	}
	
	public void function setContext(required Context context){
		variables.context = arguments.context;
	}

}
