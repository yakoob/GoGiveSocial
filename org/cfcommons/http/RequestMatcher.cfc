interface {

	public boolean function matchesRequest(required string uri, required struct requestData);
	public struct function getRequestVariables(required string uri, required struct requestData);
	public void function addURLMatcher(required URLMatcher matcher);
	public void function setHTTPMethod(required string httpMethod);
	public void function addHeader(required string name, required string value);
	public void function setContent(required string content);
	public void function setProtocol(required string protocol);

}