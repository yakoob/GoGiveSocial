import org.cfcommons.http.*;

component implements="org.cfcommons.http.RequestMatcher" {

	public SimpleRequestMatcher function init() {

		variables.urlMatchers = [];		
		variables.headers = [];
		variables.validHTTPMethods = "GET,POST,PUT,DELETE,TRACE,OPTIONS";
		
		return this;
	}
	
	/**
	 * Expects a proper string value representing a provided URL template and HTTP 
	 * request information as a structure.  The most appropriate way to invoke this
	 * method is to provide the URL as a string and then directly pass in the results
	 * of the native CF method getHTTPRequestData() such as;
	 *
	 * matchesRequest(url='/some/url', requestData=getHTTPRequestData());
	 *
	 * This method is inclusive, in that if no match criteria was previously established
	 * then a true will be returned under any condition.  Only provided criteria will be 
	 * evaluated for a match.  For instance, if HTTP method criteria was not given to 
	 * this instance (e.g,. setHTTPMethod("POST")) then any HTTP method can be presented
	 * in the request data and the evaluation for that data point will return true.
	 */
	public boolean function matchesRequest(required string uri, required struct requestData) {
		
		var matchedUrl = getMappedURLMatcher(arguments.uri);
		
		if (!isObject(local.matchedUrl))
			return false;
		
		if (structKeyExists(arguments.requestData, "headers") && !doHeadersMatch(arguments.requestData.headers))
			return false;
			
		if (!isNull(variables.protocol) && structKeyExists(arguments.requestData, "protocol") && 
			!refindNoCase(variables.protocol, arguments.requestData.protocol))
				return false;
			
		if (!isNull(variables.content) && structKeyExists(arguments.requestData, "content") && 
			!refindNoCase(variables.content, arguments.requestData.content))
				return false;	
		
		if (!isNull(variables.httpMethod) && structKeyExists(arguments.requestData, "method") && 
			!refindNoCase(variables.httpMethod, arguments.requestData.method))
				return false;
			
		// if you've made it this far, then all checks out
		return true;
	}
	
	/**
	 * It's important to ensure that the request being parsed by this method (vis-a-vis the provided
	 * url and requestData arguments) has been verified as a match via the matchesRequest() method
	 * prior to invoking this method.
	 *
	 * This method will return a structure containing keys named after each provided match criteria.
	 * for instance, if protocol was specified as match criteria by invoking the setProtocol() method
	 * and passing in a value, then "protocol" will be a key in the return structure.  If the request
	 * is a match, then the matched value of "protocol" will be returned in the structure.  This is important
	 * if regular expressions have been provided as match criteria.  If the protocol match template was 
	 * established as setProtocol("HTTP/1.1|HTTPS/1.1") (a regular expression) and the request protocol
	 * is "HTTP/1.1", then the value of the returned "protocol" key in the structure will be "HTTP/1.1".
	 *
	 * This is also important depending upon which URL variables have been declared in the registered
	 * URLMatchers.  If the following URL template exists within a registered matcher "/hello/{world}", and
	 * the request URL string value is "/hello/brian", then a key named "world" will exist in the return structure
	 * with a value of "brian".
	 */
	public struct function getRequestVariables(required string uri, required struct requestData) {
	
		// initialize the return structure
		var requestVariables = {};
		
		if (structKeyExists(arguments.requestData, "headers"))
			structAppend(requestVariables, getHeaderVariables(arguments.requestData.headers));
						
		structAppend(requestVariables, getMappedURLMatcher(arguments.uri).getPathVariables(arguments.uri));
		
		if (!isNull(variables.protocol) && structKeyExists(arguments.requestData, "protocol"))
			requestVariables.protocol = getProtocolVariable(arguments.requestData.protocol);
			
		if (!isNull(variables.httpMethod) && structKeyExists(arguments.requestData, "method"))
			requestVariables.httpMethod = getHTTPMethodVariable(arguments.requestData.method);
			
		if (!isNull(variables.content) && structKeyExists(arguments.requestData, "content"))
			requestVariables.content = getContentVariable(arguments.requestData.content);
					
		return requestVariables;
	}
	
	/**
	 * Accepts a string value with which the request HTTP method will
	 * be matched against.  This can accept a regular expression for 
	 * added flexibility such as setHTTPMethod("GET|POST"); in which
	 * case either "GET" OR "POST" will be acceptable HTTP methods 
	 * when this instances matchesRequest() is invoked.
	 */
	public void function setHttpMethod(required string httpMethod) {
		variables.httpMethod = arguments.httpMethod;
	}
	
	/**
	 * Accepts a key and a value representing a header name and associated
	 * value that the request should attempt to match when matchesRequest() is 
	 * invoked.  The value for "value" can be a regular expression for added
	 * matching flexibility or an increased level of filtering.
	 */
	public void function addHeader(required string name, required string value) {
	
		var header = {
			name = arguments.name,
			value = arguments.value
		};
		
		// now add it to the collection
		arrayAppend(variables.headers, header);
	}
	
	/**
	 * Accepts a string value with which the request raw content
	 * be matched against.  Can accept a regular expression for added
	 * matching flexibility or an increased level of filtering.
	 */
	public void function setContent(required string content) {
		variables.content = arguments.content;
	}
	
	/**
	 * Accepts a string value with which the request protocol
	 * be matched against.  Can accept a regular expression for added
	 * matching flexibility or an increased level of filtering.
	 */
	public void function setProtocol(required string protocol) {
		variables.protocol = arguments.protocol;
	}
	
	/**
	 * Must provide an implementation of the URLMatcher interface
	 * to this method.  Each URL matcher registered with the RequestMatcher
	 * will be evaluated in the order they were added and are considered
	 * when matching the entire request via matchesRequest()
	 */
	public void function addURLMatcher(required URLMatcher matcher) {
		arrayAppend(variables.urlMatchers, arguments.matcher);
	}
	
	private boolean function doHeadersMatch(required struct requestHeaders) {

		// iterate through all registered header conditions
		for (var i = 1; i <= arrayLen(variables.headers); i++) {
		
			var header = variables.headers[i];
			
			// does the header exist?
			if (!structKeyExists(arguments.requestHeaders, header.name))
				return false;
			
			// if the header exists, check for equality
			if (!refindNoCase(header.value, arguments.requestHeaders[header.name]))
				return false;
		
		}
		
		// if you've made it this far, then everything checks out
		return true;
	}
	
	private struct function getHeaderVariables(required struct requestHeaders) {
	
		// initialize the return structure
		var headerVariables = {};
		
		// iterate through all registered header conditions
		for (var i = 1; i <= arrayLen(variables.headers); i++) {
		
			var header = headers[i];
			
			// does the header exist?
			if (!structKeyExists(arguments.requestHeaders, header.name))
				continue;
				
			var value = rematchNoCase(header.value, arguments.requestHeaders[header.name]);
			
			if (!arrayLen(value))
				continue;
				
			headerVariables[header.name] = value[1]; 
		}
		
		return headerVariables;
	}
	
	private string function getProtocolVariable(required string protocolHeaderValue) {
	
		if (isNull(variables.protocol))
			return "";
	
		var value = rematchNoCase(variables.protocol, arguments.protocolHeaderValue);
			
		if (!arrayLen(value))
			return "";
			
		return value[1];
	}
	
	private string function getHTTPMethodVariable(required string httpMethodValue) {
	
		if (isNull(variables.httpMethod))
			return "";
	
		var value = rematchNoCase(variables.httpMethod, arguments.httpMethodValue);
			
		if (!arrayLen(value))
			return "";
			
		return value[1];
	}
	
	private string function getContentVariable(required string contentValue) {

		if (isNull(variables.content))
			return "";
	
		var value = rematchNoCase(variables.content, arguments.contentValue);
			
		if (!arrayLen(value))
			return "";
			
		return value[1];
	}
	
	/**
	 * Will return either an instance of URLMatcher if a previously
	 * registered matcher matches the provided URL string OR a false
	 * if no match is found.
	 */
	private any function getMappedURLMatcher(required string uri) {
	
		// look for a match
		for (var i = 1; i <= arrayLen(variables.urlMatchers); i ++) {
			var matcher = variables.urlMatchers[i];
			if (local.matcher.matchesURI(arguments.uri))
				return matcher;
		}
		
		// if no matcher was found, return null
		return false;
	}

}