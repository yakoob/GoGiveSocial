component accessors="true" extends="org.cfcommons.http.impl.SimpleURLMatcher" {

	property string httpMethods;
	property string securityExpression;

	public SecurityURLFilter function init() {
		return this;
	}
	
	public boolean function hasHttpMethod(required string httpMethod) {
		if (!listFindNoCase(variables.httpMethods, arguments.httpMethod))
			return false;
			
		return true;
	}

}