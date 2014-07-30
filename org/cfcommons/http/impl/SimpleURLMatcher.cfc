import org.cfcommons.http.*;

/**
 * This class provides a mechanism to configure AND match a provided URI.  Configuration of the Matcher
 * is provided by the argument to the setConfig() method and must adhere to the following format; <br /> <br />
 * 
 * <pre>
 * /heres/my/url <br />
 * /blog/{year}/{month}/{day}
 * </pre>
 * <pre>
 * matcher = new SimpleURLMatcher("/user/{id}"); <strong>OR</strong> <br />
 * matcher.setConfig("/user/{id}");
 * </pre> 
 *
 * Strings wrapped in curly-braces demarcate URL variables.  URL variables represent values that can "vary" at
 * that spot in the provided URL.  Once an instance of the matcher has been configured via a constructor arg OR
 * through the setConfig() method, you can now ask it what values will match the configuration via the matchesUri()
 * method which will return either a true or false.
 *
 * <pre>
 * results = matcher.matchesUri("/user/2");
 * </pre>
 *
 * The above call (based on the example configuration) will return true whereas the following will return false;
 *
 * <pre>
 * results = matcher.matchesUri("/user/2/roles");
 * </pre> 
 *
 * Upon a successful match, you can then extrapolate the values of the declared URI variables with the
 * getPathVariables() method passing in the same value that was used as an argument to the matchesUri()
 * invocation (which returned true).
 *
 * <pre>
 * values = matcher.getPathVariables("/user/2");
 * </pre> 
 *
 * Again, based off of the example configuration of /user/{id} the results of the call to getPathVariables() will
 * return a structure with two keys - one with a name of "id" (per the configuration) with an associated value of "2".
 * Another key will be "_extension" which is always returned from this invocation and will contain the exact value of 
 * any extension that was passed in.  For example;
 *
 * <pre>
 * results = matcher.matchesUri("/user/2.xml");
 * </pre>
 *
 * Will populate the "_extension" path variables structure entry with the value of ".xml"
 *
 */
component accessors="true" implements="org.cfcommons.http.URLMatcher" {

	property string config;
	property array uriVarArray;
	property string uriRegexMatcher;
	
	public URLMatcher function init(string template) {
		
		// initialize some needed variables
		this.setUriVarArray([]);
		this.setUriRegexMatcher("");
		
		// allow optional configuration when instance is constructed
		if (!isNull(arguments.template))
			this.setTemplate(arguments.template);
		
		return this;	
	}
	
	public void function setTemplate(required String template) {
		variables.config = arguments.template;
		
		var uriVarArray = buildUriVarArray();
		setUriVarArray(local.uriVarArray);
								
		var matcher = buildDynamicRegexMatcher(local.uriVarArray);
		setUriRegexMatcher(local.matcher);
	}
	
	public boolean function matchesUri(required String uri) {
		var matchResults = refind(variables.uriRegexMatcher, arguments.uri, 1, true);
		
		if (arrayLen(local.matchResults.LEN) <= 1) {
			return false;
		}
		
		return true;
	}
	
	public Struct function getPathVariables(required String uri) {
		var matchResults = refind(variables.uriRegexMatcher, arguments.uri, 1, true);
						
		if (arrayLen(local.matchResults.LEN) <= 1) {
			return {};
		}

		var uriVars = createURIVarReference();
						
		var uriVarStruct = getPopulatedURIVarStruct(uriVars, local.matchResults, arguments.uri);
				
		local.uriVarStruct._extension = getFormat(arguments.uri, local.matchResults);
		
		return local.uriVarStruct;
	}
	
	private String function buildDynamicRegexMatcher(required Array varArray) {
		var matcher = variables.config;
		var currentReference = "";
		var prefix = "^";
		var suffix = "(\..*)?$";
		var i = 1;
											
		for (; local.i <= arrayLen(arguments.varArray); local.i++) {
			local.currentReference = arguments.varArray[local.i];
						
			/*
			 * First, let's check to see if a custom matcher was passed in,
			 * if so - then we need to pull it out.  Custom matchers are defined as such:
			 *
			 * /my/custom/url/matcher/{text:[hello|world]}
			 *
			 * Any value succeeding the ":" in the url variable declaration will be assumed to
			 * be a valid regular expression. In the above example, the "text" variable must be
			 * either "hello" OR "world" in order for a match to occurr.
			 */
			 
			if (find(":", local.currentReference)) {
				var custom = rematch("\:(.*)", local.currentReference);
				local.custom = rereplace(local.custom[1], "[:\}\{]", "", "one");
				// now wipe out the last occurrence of "}"
				local.custom = rereplace(local.custom, "\}(?!.*\})", "", "one");
				var exp = "(" & local.custom & ")";
				
			/*
			 * If no custom matcher was passed in, then we're simply going to use
			 * the following regex to match any alpha-numeric combination including
			 * dashes.
			 */
			} else {
				var exp = "([\w*-]*)";
			}
																							
			local.matcher = replace(local.matcher, local.currentReference, local.exp);
		}
		
		local.matcher = local.prefix & local.matcher & local.suffix;
												
		return local.matcher;
	}
	
	private Array function buildUriVarArray() {
		/*
		 * We're going to parse out anything and everything that has been wrapped in
		 * curly-braces in the config - as those are URI variable declarations.  forward-slashes
		 * is the primary delimiter.
		 */
		var uriVars = rematch("\/(\{.*?\}\}?)", variables.config);
		
		// we need to ensure any forward-slashes have been removed from the final values
		var i = 1;
		for (; local.i <= arrayLen(local.uriVars); local.i++) {
			local.uriVars[local.i] = replace(local.uriVars[local.i], "/", "", "one");
		}
				
		return local.uriVars;
	}
	
	private String function getFormat(required String uri, required Struct regexMatchStruct) {
		var lastPosition = arrayLen(arguments.regexMatchStruct.POS);
		var format = false;
						
		if (arguments.regexMatchStruct.POS[local.lastPosition] eq 0 and arguments.regexMatchStruct.POS[local.lastPosition] eq 0) {
			return "";
		}
		
		local.format = mid(arguments.uri, arguments.regexMatchStruct.POS[local.lastPosition], 
			arguments.regexMatchStruct.LEN[local.lastPosition]);
			
		return local.format;
	}
	
	private Array function createUriVarReference() {
		var template = getUriVarArray();
		var currentReference = false;
		var populatedUriVars = [];
		var i = 1;
								
		for (; i <= arrayLen(template); i++) {
			local.currentReference = variables.uriVarArray[i];
			// if a custom matcher was passed in, we need to strip it out
			if (find(":", local.currentReference)) {
				// need to parse out the custom matcher so that only the raw variable is returned
				var rawVar = rematch("(.*)\:", local.currentReference);
				var rawVar = rereplace(local.rawVar[1], "[:|\}|\{]", "", "all");
				arrayAppend(local.populatedUriVars, local.rawVar);
			} else {
				arrayAppend(local.populatedUriVars, rereplace(local.currentReference, "[\{*}*]", "", "all"));
			}
		}
		
		return local.populatedUriVars;
	}
	
	private Struct function getPopulatedUriVarStruct(required Array varTemplate, required Struct matchResults, required String uri) {
		var populatedVarStruct = {};
		var position = false;
		var varname = false;
		var i = 2;
		
		if (!arrayLen(arguments.varTemplate)) {
			return local.populatedVarStruct;
		}
		
		for (; local.i <= arrayLen(arguments.matchResults.POS); local.i++) {
			local.position = local.i - 1;
			local.varname = arguments.varTemplate[position];
			
			structInsert(local.populatedVarStruct, local.varname, mid(arguments.uri, 
				arguments.matchResults.POS[local.i], arguments.matchResults.LEN[local.i]));
				
			if (local.position == (arrayLen(arguments.matchResults.POS) - 2)) {
				break;
			}
		}

		return local.populatedVarStruct;
	}

}