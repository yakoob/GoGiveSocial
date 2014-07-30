/**
 * This component directly introspects HTTPRequestData looking for an
 * "authorization" header and filters out basic authentication credentials
 * based off of header information.  If the "authorzation" header does not exist in the request,
 * than an empty structure will be returned.  If it does exist, the resulting
 * structure will contain both a "username" and "password" key, each with
 * it's respective value populated from the header information.
 */
component implements="org.cfcommons.http.AuthenticationFilter" {

	public BasicAuthenticationFilter function init() {
		return this;
	}

	/**
	 * This method doesn't require any arguments as it looks directly at
	 * HTTP request "authorization" header produced by the page context within
	 * which the parent object instance was created.  This method will return
	 * an empty structure if no HTTP Basic authentication credentials were passed
	 * in the request header.  If "authorization" headers were passed in, then the
	 * Base64 encoded username and password values will be parsed out and placed in 
	 * respective "username" and "password" keys in the resulting structure.
	 */
	public struct function getAuthenticationCredentials() {
		
		var credentials = {};
		
		// if no authorization headers are being passed in, return an empty structure
		if (!structKeyExists(getHttpRequestData().headers, "authorization"))
			return credentials;
		
		// parse out the username and password information		
		var authString = toString(binaryDecode(listLast(getHttpRequestData().headers.authorization, " "),
			"base64"));
			
		credentials.username = getToken(local.authString, 1, ":");
		credentials.password = getToken(local.authString, 2, ":");
	
		return credentials;
	}

}