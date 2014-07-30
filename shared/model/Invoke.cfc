component{
	
	public any function onMissingMethod( missingMethodName, missingMethodArguments ){			
		for ( local.val in application.context.ioc.getClasses() ){			
			local.x = listlast(val, ".");			
			if (arguments.missingMethodName == x) 
				return application.context.ioc.getObjectInstance(class=val);									
		}				
		throw(message="Dude, you cannot invoke a class called #arguments.missingMethodName# when the class itself doesn't even exist. OK. RTFM, then get back to me");
		abort;
	}
}
