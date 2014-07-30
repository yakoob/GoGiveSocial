interface extends="org.cfcommons.http.RequestMatcher" {

	public void function setMethodName(required string methodName);
	public void function setObject(required any object);
	public void function setClassName(required string className);
	public any function mapRequest(required string uri, required struct requestData);

}