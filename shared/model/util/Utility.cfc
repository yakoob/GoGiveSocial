/**
* @accessors true
* @extends shared.model.Object
*/
component {
	
	public Utility function init(){
		return this;
	}

	/**
	* @output false
	* @hint Accepts a struct and returns a new struct with key/value pairs taken from original struct -- but only for those keys that are declared properties of this class
	*/
	public struct function restrictToDeclaredProperties( required string className, required struct struct ){
		var declaredProperties = new org.cfcommons.reflection.impl.ComponentClass( class=arguments.className ).getAllProperties(); // an array
		var s = {};
		var propName = '';
		
		for ( var i=1; i <= ArrayLen( declaredProperties ); i++ ){
			propName = declaredProperties[ i ].name;
			if( StructKeyExists( arguments.struct, propName ) ){
				s[ propName ] = arguments.struct[ propName ];
			};
		};	
		return s;
	}


	public string function cleanScriptName(){		
		if (len(cgi.PATH_INFO >=2))
			return mid(cgi.PATH_INFO,"2",len(cgi.PATH_INFO));
		else
			return cgi.PATH_INFO;		
	}

	public void function sleep(string sleep="5000"){
		var thread = CreateObject("java", "java.lang.Thread");	
		thread.sleep(arguments.sleep);	
	}
	
}
