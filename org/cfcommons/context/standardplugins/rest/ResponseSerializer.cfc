component {

	public ResponseSerializer function init() {
		return this;
	}
	
	public boolean function canSerialize(any obj, string format="") {
					
		if (isNull(arguments.obj))
			return false;
		
		// xml needs special handling - so make sure that this step does not consider it
		if (isSimpleValue(arguments.obj) && !isXML(arguments.obj))
			return true;
			
		if (arguments.format == "xml" && isSimpleValue(arguments.obj) && isXML(arguments.obj))
			return true;
				
		if (isDefined("arguments.obj.toString") && isCustomFunction(arguments.obj.toString))
			return true;
		
		if (isDefined("arguments.obj.to#arguments.format#"))
			return true;
		
		if (isArray(arguments.obj) && arguments.format == "json")
			return true;
		
		if (isQuery(arguments.obj) && arguments.format == "json")
			return true;
		
		if (isStruct(arguments.obj) && !isObject(arguments.obj) && arguments.format == "json")
			return true;
		
		return false;
	}
	
	/**
	 * When the context implements the autoserialization response strategy, a process
	 * is followed to determine which version of autoserialization is the most appropriate.
	 * This method is responsible for that decision-making process.  Each step in the process is
	 * followed in order - when one condition is false, then the next is evaluated in succession.
	 *
	 * 1. Is a specific format being requested and if so, does the return-type expose
	 *		an api that will allow us to return the format being requested? (e.g., if the 
	 *		requested format is 'json' via /myobject.json, then does the return type provide
	 * 		a 'toJson' method, if so, that method is invoked and the results of that invocation
	 *		are pushed out to the client.
	 *
	 * 2. Does the resulting object expose a 'toString()' method?  If so, invoke it and push the results
	 *		of that invocation to the client.
	 *
	 * 3. Is the return type either an Array or a Structure AND is the requested format "xml" or "json"?
	 *		If so, then serialize the struct or array into json or xml and return those results to the client.
	 *
	 */
	public string function serialize(required any obj, required String format) {
		
		// xml is easy to turn into a string;
		if (arguments.format == "xml" && isSimpleValue(arguments.obj) && isXML(arguments.obj)) {
			return toString(arguments.obj);
		}
					
		/*
		 * We're going to check to see if this custom return type exposes
		 * a method that maps directly to the requested format.
		 */
		if (isDefined("arguments.obj.to#arguments.format#")) {
			return evaluate("arguments.obj.to#arguments.format#()");
		}
				
		/*
		 * When a custom type is returned from the main method invocation (controller method)
		 * AND if that object exposes a 'toString()' method - then that takes precidence AS LONG
		 * AS the requested format is not '.xml' or '.json'.
		 */
		if (isDefined("arguments.obj.toString") && (arguments.format != "xml" && arguments.format != "json")) {
			return arguments.obj.toString();
		}
		
		/*
		 * IF the object is one of the following (as long as the format is .json) then we can auto
		 * serialize;
		 * 1. Simple Value (string, number)
		 * 2. Array
		 * 3. Structure
		 * 4. Query
		 */
		if ((isSimpleValue(arguments.obj) || isArray(arguments.obj) || (isStruct(arguments.obj) || 
			isQuery(arguments.obj)) && !isObject(arguments.obj))) {
		
			return serializeJSON(arguments.obj);
		}
		
		/*
		 * If you've made it this far, then serialization cannot be accomplished.
		 * Make sure the implemeting code knows this.
		 */
		throw(type="CannotSerializeTypeException", message="Cannot serialize the provided type");
	}

}