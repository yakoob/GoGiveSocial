/**
 * This component provides the means to manage the "state" of an
 * iteration through each line of a tag-based CFC source file.  As long as the contents
 * of a CFC source code file (*.cfc) is iterated through line by line, and each
 * source line is fed into the setLine() method, then each method
 * will return accurate and relevant information on the state of 
 * the iteration itself - such as whether or not, for the current
 * source line, you're inside of a method declaration or at the beginning
 * of a method declaration.
 */
component implements="org.cfcommons.reflection.internal.SourceParser" {

	public TagSourceParser function init() {
	
		variables.lineCount = 0;
		variables.isEndOfMethod = false;
		variables.isStartOfMethod = false;
		variables.previousLine = "";
		variables.currentLine = "";
		variables.inMethod = false;
		variables.methodName = "";
	
		return this;
	}
	
	/**
	 * Must be invoked for every line within a CFC source file, starting with the first
	 * line in the file in order to maintain proper state.
	 */
	public void function setLine(required string line) {
	
		variables.lineCount++;
		variables.isEndOfMethod = false;
		variables.currentLine = arguments.line;
		
		if (countMatches("\<\/.*cffunction", variables.previousLine)) {
			variables.inMethod = false;
			variables.methodName = "";
		}
		
		// are we entering a method declaration?
		if (!variables.inMethod && countMatches("\<\s*cffunction", variables.currentLine)) {

			// we're in a method now!
			variables.inMethod = true;
			variables.isStartOfMethod = true;
			
			// extrapolate the method name
			variables.methodName = parseMethodName(variables.currentLine);
		} else {
			variables.isStartOfMethod = false;
		}
		
		/*
		 * Check to see if this is the very last line
		 * in a method declaration.
		 */
		if (variables.inMethod && countMatches("\<\/.*cffunction", variables.currentLine)) {
			variables.isEndOfMethod = true;
		}
		
		variables.previousLine = currentLine;
						
	}
		
	/**
	 * Will return true only if the current active source 
	 * line is the beginning of a method declaration, e.g.;
	 *
	 * <cffunction name="test" ../> or
	 *
	 * public void funciton test() {...
	 *
	 */
	public boolean function isBeginningOfMethod() {
		return variables.isStartOfMethod;
	}
	
	/**
	 * Returns the line number of the current
	 * active source line.
	 */
	public numeric function getCurrentLineNumber() {
		return variables.lineCount;
	}
	
	/**
	 * Will always return true for this
	 * type.
	 */
	public boolean function inScript() {
		return false;
	}
	
	/**
	 * Will always return false for
	 * this type.
	 */
	public boolean function inTags() {
		return true;
	}
	
	/**
	 * Will return true as long as the current active
	 * source line represents source code that is a member
	 * of a function declaration.  Will also return true
	 * for lines representing the end of the method.
	 */
	public boolean function inMethod() {
		return variables.inMethod;
	}
	
	/**
	 * Will return a string containing the name
	 * of a declared class method as long as the current
	 * active source line is contained within a method declaration.
	 * Otherwise, this method will return an empty string.
	 */
	public string function getCurrentMethodName() {
		return variables.methodName;
	}
	
	/**
	 * Will return true if the current active source
	 * line represents the very last line in a method
	 * declaration.
	 */
	public boolean function atEndOfMethod() {
		return variables.isEndOfMethod;
	}
	
	/**
	 * Will return true if the current source represents actual implementation code which
	 * this parser defines as any code declared within a method that is not
	 * an empty string.
	 */
	public boolean function inImplementation() {
			
		if (len(trim(variables.currentLine)) == 0) {
			return false;
		}
		
		if (!this.inMethod()) {
			return false;
		}
				
		return true;
	}
	
	/**
	 * Will return a boolean true if and only if a "return" declaration
	 * is found on the current source line.
	 */
	public boolean function atReturn() {
		return countMatches("\<\s*cfreturn", variables.currentLine);
	}
	
	/**
	 * Extrapolates the name of the a method declaration as long as the
	 * current active line is the beginning of such a declaration.
	 */
	private string function parseMethodName(required string line) {
		var results = refindNoCase("name\s*\=\s*['|""]?([\w])*['|""]?", arguments.line, 1, true);
		var name = mid(arguments.line, results.pos[1], results.len[1]);
		
		/*
		 * TODO: Refactor this - very inefficient approach to extrapolating
		 * the correct 'name' attribute value from the <cffunction /> tag.
		 */
		local.name = rereplaceNoCase(local.name, "name", "", "all");
		local.name = rereplaceNoCase(local.name, "['|""]", "", "all");
		local.name = rereplaceNoCase(local.name, "=", "", "all");
		return local.name;
	}
	
	/**
	 * Uses an instance of the Java based java.util.regex.Pattern class
	 * with the provided "regex" argument to sum up the number of times the
	 * regex finds a match within the provided "string" argument. 
	 */
	private numeric function countMatches(required string regex, required string string) {
	
		var pattern = getPattern();
		var matcher = pattern.compile(arguments.regex).matcher(arguments.string);
		
		for (var count = 0; matcher.find(); count++);
		
		return count;
	}
	
	private any function getPattern() {
		return createObject("java", "java.util.regex.Pattern");
	}

}