import org.cfcommons.context.*;
import org.cfcommons.http.impl.*;
import org.cfcommons.http.*;
import org.cfcommons.http.impl.*;

component implements="org.cfcommons.context.HTTPPlugin" {

	public PowernapPlugin function init(string uriMarker="cfcommons:rest:uri", string httpMethodMarker="cfcommons:rest:httpMethod",
		string defaultFormat="json", boolean debug=false, boolean restfulResponses=true, array contentTypes) {
		
		// trace(type="information", text="PowernapPlugin: Initializing plugin.");
		
		variables.debug = arguments.debug;
		variables.defaultFormat = arguments.defaultFormat;
		variables.restfulResponses = arguments.restfulResponses;
		variables.uriMarker = arguments.uriMarker;
		variables.httpMethodMarker = arguments.httpMethodMarker;
		
		variables.basicAuthenticationFilter = new BasicAuthenticationFilter();
		variables.headerService = new HeaderService();
		variables.responseSerializer = new ResponseSerializer();
		variables.contentTypeMapping = new ContentTypeMapping();
		
		variables.standardAcceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
		
		variables.matchers = {
				GET = []
			,	PUT = []
			,	POST = []
			,	DELETE = []
			,	OPTIONS = []
			,	TRACE = []
		};
				
		// were custom content types passed in?
		if (!isNull(arguments.contentTypes))
			$registerCustomContentTypes(arguments.contentTypes);
				
		return this;
	}
	
	public numeric function getVersion() {
		return 1.0;
	}
	
	public void function setContext(required Context context) {
		variables.context = arguments.context;
	}
	
	public Context function getContext() {
		return variables.context;
	}
	
	public string function getResponse(string response) {
					
		var matchRegistry = variables.matchers[cgi.request_method];
			
		for (var i = 1; i <= arrayLen(matchRegistry); i++) {
		
			var matcher = matchRegistry[i];
			var urlMatcher = matcher.getURLMatcher();
			
			if (urlMatcher.matchesURI(cgi.path_info)) {
			
				/* 
					trace(type="information", text="PowernapPlugin: Matched request to resource for URI; " & 
					cgi.path_info & " and http method " & cgi.request_method);
				*/
					
				var data = getHTTPRequestData();
				structAppend(data, urlMatcher.getPathVariables(cgi.path_info));
				structAppend(data, form);
				structAppend(data, url);
				structAppend(data, request);
				
				// was raw put or post information submitted?
				if (!isNull(data.content) && isSimpleValue(data.content) && len(trim(data.content))) {
					var rawData = $serializeRawContent(data.content);
					structAppend(data, rawData);
				}
								
				// how should the resource represent itself as?			
				data._extension = $negotiateContentType(data);
								
				// append basic HTTP authentication information if it exists
				structAppend(data, variables.basicAuthenticationFilter.getAuthenticationCredentials());
				
				// process the request
				return $processRequest(matcher.getResourceMapping(), cgi.path_info, data);
			}
			
		}
	
		// trace(type="information", text="PowernapPlugin: No matched resource for URI; " & cgi.path_info);
		
		/*
		 * If restful responses are enabled - then we terminate the request and respond with a
		 * 404 if no resource matches were found.
		 */
		if (variables.restfulResponses) {
			variables.headerService.suppressDebugOutput();
			variables.headerService.addStatusCodeHeader(404);
		}
	
		return arguments.response;
	}
	
	public void function read(required any class) {
	
		// iterate through each method to see if it's been annotated
		var methods = arguments.class.getMethodsAnnotatedAs(variables.uriMarker);
		
		for (var i = 1; i <= arrayLen(methods); i++) {
		
			var method = methods[i];
			
			// trace(type="information", text="PowernapPlugin: Registering request matcher for #method.getName()#()");
			
			var url = method.getAnnotation(variables.uriMarker);
			var httpMethods = method.getAnnotation(variables.httpMethodMarker);
			
			var requestMatcher = new RestRequestMatcher();
			var mapping = new ResourceMapping();
			var urlMatcher = new SimpleURLMatcher(url);
			
			mapping.setClassname(method.getParentClass().getFullName());
			mapping.setMethodName(method.getName());
			
			requestMatcher.seturlMatcher(urlMatcher);
			requestMatcher.setResourceMapping(mapping);
			
			// add a matcher to each httpmethod array
			for (var h = 1; h <= listLen(httpMethods); h++) {
				var method = trim(listGetAt(httpMethods, h));
				arrayAppend(variables.matchers[method], requestMatcher);
			}
		
		}
	
	}
	
	// not needed
	public void function finalize() {}
	public void function postContextConstruct() {}
	
	private string function $processRequest(required ResourceMapping mapping, required string URL, required struct requestData) {
		
		// obtain an instance of the target resource from the central factory
		var resource = variables.context.getObjectInstance(arguments.mapping.getClassName());
		var ext = replace(arguments.requestData._extension, ".", "", "one");
		
		// look for security exceptions - we want to return a 401 (unauthorized) status code in those cases
		try {
			
			// invoke the correct resource method
			var results = evaluate("local.resource.#arguments.mapping.getMethodName()#(argumentCollection=arguments.requestData)");
		
		/*
		 * We want to look for exceptions of type 'SecurityException', if they exist - then 
		 * we'll return a Basic HTTP Authentication challenge.
		 */
		} catch (SecurityException e) {
			variables.headerService.addStatusCodeHeader(statusCode=401);
			variables.headerService.addHeader(name="WWW-Authenticate", value="Basic realm='Powernap Rest Resource'");
			// very important to terminate the request and flush the response buffer;
			abort;
		}
		
		// is there a status code being returned?
		if (!isNull(results) && isStruct(results) && structKeyExists(results, "statusCode")) {
			variables.headerService.addStatusCodeHeader(results.statusCode);
			// now remove it
			structDelete(results, "statusCode");
		}
		
		// is an explicit response being returned
		if (!isNull(results) && isStruct(results) && structKeyExists(results, "response")) {
			// reassign to the 'results' variable
			local.results = results.response;
		}
		
		if (!isNull(results) && variables.responseSerializer.canSerialize(results, ext))
			var results = variables.responseSerializer.serialize(results, ext);
		else
			throw(type="RepresentationSerializationException", message="Was unable to serialize representation for the requested resource");
		
		// suppress debug output if configuration requires is
		if (!variables.debug)
			variables.headerService.suppressDebugOutPut();
			
		// now ensure the correct mime/content-type header is returned;
		var type = variables.contentTypeMapping.getMimeTypeFromExtension(ext);
				
		variables.headerService.addHeader(name="Content-Type", value=type);
		
		return results;
	}
	
	private string function $negotiateContentType(required struct requestData) {
	
		// providing an explicit extension takes precedence
		if (len(trim(arguments.requestData._extension)))
			return arguments.requestData._extension;
			
		// if neither condition applies, then use the default format 
		return variables.defaultFormat;
	}
	
	private struct function $serializeRawContent(required string content) {
			
		var results = {};	
			
		if (isBinary(arguments.content))
			var data = toString(arguments.content);
		else
			var data = arguments.content;
						
		if (len(trim(data)) && isJSON(data))
			results = deserializeJSON(data);
				
		return results;
	}
	
	private void function $registerCustomContentTypes(required array types) {
	
		for (var i = 1; i <= arrayLen(arguments.types); i++) {
			var type = arguments.types[i];
			
			if (!isStruct(type)) {
				throw(type="InvalidContentTypeDeclaration", message="Custom content types must be provided
					as structures with the extension (without the preceeding period) as the key, and content-type as the value");
			}
			
			// register the custom type
			variables.contentTypeMapping.addType(format=type.format, contentType=type.contentType);
		}
	
	}

}