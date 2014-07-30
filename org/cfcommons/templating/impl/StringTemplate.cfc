import org.cfcommons.templating.*;

component implements="org.cfcommons.templating.Template" {

	/**
	 * Must be initialized with a string value or another Template instance.
	 * If an invalid content type is provided then an exception of type
	 * InvalidContentTypeException will be thrown.
	 */
	public Template function init(required any content) {
	
		if (isInstanceOf(content, "org.cfcommons.templating.Template")) {
			variables.content = arguments.content.getContent();
		} else if (isSimpleValue(arguments.content)){
			variables.content = arguments.content;
		} else {
			throw(type="InvalidContentTypeException", message="Invalid Content Argument",
				detail="The 'content' provided to the template can only be a simple value or
				another Template instance.");
		}
	
		return this;
	}
	
	public void function setContent(required string content) {
		variables.content = arguments.content;
	}
	
	public string function getContent() {
		return variables.content;
	}
		
	/**
	 * Provides a case-insensitive search and replace mechanism to 
	 * replace template contents.  All instances of the search keys
	 * will be replaced in the template.  Valid regular expressions are accepted 
	 * as a part of the keyValues 'key'.  Ensure that any regex special
	 * characters that are passed in as a part of one of the keys are escaped
	 * with a backslash;
	 
	 * <pre>
	 * replaceMe = {};
	 * replaceMe["\?"] = "!";
	 * results = template.replace(replaceMe);
	 * </pre>
	 *
	 * If the backslash before the question mark is omitted, than an exception
	 * will be thrown because the regex will be invalid.  The above replacement
	 * command will replace all isntances of a quesiton mark "?" with an exclamaition
	 * point.
	 *
	 * If you do not intend on replacing any special characters or strings with 
	 * whitespace characters within the template,
	 * you can pass in the structure command inline as such;
	 *
	 * <pre>
	 * results = template.replace({hello="goodbye"});
	 * </pre>
	 *
	 */
	public string function replace(required struct keyValues) {
		// iterate through the structure find and replace via regex
		for (key in arguments.keyValues) {
			variables.content = rereplaceNoCase(variables.content, key, 
				arguments.keyValues[key], "all");
		}
		
		return variables.content;
	}
	
	public string function replaceBetweenTags(required string string, required string tag,
		required string replacement) {
		
		var regex = '<#arguments.tag#\b[^>]*>(.*?)</#arguments.tag#\>';
		var newString = arguments.string;
	
		start = 1;
		do {
		
			results = refind(regex, arguments.string, start, true);
					
			if (arrayLen(results.POS) < 2)
				break;
				
			start = results.POS[2];
			
			var stringToReplace = mid(string, results.POS[2], results.LEN[2]);
			newString = replace(newString, stringToReplace, arguments.replacement, 'one');
			
		} while (arrayLen(results.POS) == 2);
			
		return newString;
	}
	
}