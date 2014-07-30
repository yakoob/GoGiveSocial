component accessors="true" {

	/**
	 * Represents the cannonical names of each
	 * 'advice' method that should be applied.
	 *
	 * @getter false
	 */
	property array adviceNames;
	
	/**
	 * Can only be 'before', 'after' or 'around'.
	 * No other values are valid.
	 */
	property string joinPoint;
	
	/**
	 * Represents the full component name of the
	 * CFC within which the affected method exists, e.g;
	 * com.mydomain.MyObject
	 */
	property string className;
	
	/**
	 * Represents the name of the method that requires
	 * one or more cross-cutting-concerns.  The method
	 * name value must be the name of an actual public
	 * method exposed by the component per the className
	 * value.
	 */
	property string methodName;
	
	public PointCut function init() {
		variables.adviceNames = [];
		variables.validJoinPoints = "before,after,around";
		return this;
	}
	
	public void function addAdviceName(required string adviceName) {
		arrayAppend(variables.adviceNames, arguments.adviceName);
	}
	
	public boolean function hasAdviceName(required string adviceName) {
		return arrayContains(variables.adviceNames, arguments.adviceName);
	}
	
	public void function setJoinPoint(required string joinPoint) {
	
		if (!listContains(variables.validJoinPoints, arguments.joinPoint)) {
			throw(message="Invalid Join Point", detail="The join point '#arguments.joinPoint#' is invalid.
				Only supported types are; #variables.validJoinPoints#");
		}
		
		variables.joinPoint = arguments.joinPoint;
	}

}