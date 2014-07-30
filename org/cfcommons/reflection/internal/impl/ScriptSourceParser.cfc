/**
 * This component provides the means to manage the "state" of an
 * iteration through each line of a script-based CFC source file.  As long as the contents
 * of a CFC source code file (*.cfc) is iterated through line by line, and each
 * source line is fed into the setLine() method, then each method
 * will return accurate and relevant information on the state of 
 * the iteration itself - such as whether or not, for the current
 * source line, you're inside of a method declaration or at the beginning
 * of a method declaration.
 */
component implements="org.cfcommons.reflection.internal.SourceParser" {

	public ScriptSourceParser function init() {
	
		variables.lineCount = 0;
		variables.isEndOfMethod = false;
		variables.isStartOfMethod = false;
		variables.previousBraceDelta = 0;
		variables.previousLine = "";
		variables.currentLine = "";
		variables.braceDelta = 0;
		variables.openBraces = 0;
		variables.closedBraces = 0;
		variables.braceDelta = 0;
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
		variables.previousLine = currentLine;
		variables.currentLine = arguments.line;
		variables.braceDelta = calculateBraceDelta(arguments.line);
		
		// are we entering a method declaration?
		if (!variables.inMethod && refindNoCase("(public|package|private|remote).*function", variables.currentLine)) {
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
		if (variables.previousBraceDelta >1 && variables.braceDelta == 1 && variables.inMethod) {
			variables.isEndOfMethod = true;
		/*
		 * If we're tracking a method AND the open bracket count 
		 * minus the closed bracket count are exactly equal to 1 (inside a CFC will always be 1) 
		 * - method is closed.
		 */
		} else if (variables.inMethod && variables.braceDelta == 1) {
			variables.inMethod = false;
			variables.methodName = "";
		}
		
		variables.previousBraceDelta  = variables.braceDelta;
				
	}
		
	/**
	 * Will return true only if the current active source 
	 * line is the beginning of a method declaration, e.g.;
	 *
	 * <cffunction name="test" ../> or
	 *
	 * public void funciton test() {...
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
		return true;
	}
	
	/**
	 * Will always return false for
	 * this type.
	 */
	public boolean function inTags() {
		return false;
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
		return countMatches("return(\\s|;|)", variables.currentLine);
	}
	
	/**
	 * Taking into consideration ONLY braces (} or {) that are members of
	 * the CFC source file used to create the source file (not ones that exist
	 * within string instances), will return the number of open braces minus the number
	 * of closed braces.  Upon entering an iteration through the source of a script-based
	 * CFC, the value returned from this method will always be greater than 1 (an open brace is
	 * required to begin a script-based CFC).  Only when the end of the source file is reached
	 * with this method return a zero.
	 */
	private numeric function getBraceDelta() {
		return variables.braceDelta;
	}
	
	/**
	 * Extrapolates the name of the a method declaration as long as the
	 * current active line is the beginning of such a declaration.
	 */
	private string function parseMethodName(required string line) {
		var filteredLine = replace(trim(arguments.line), chr(9), "", "all");
		local.results = refindNoCase("[public|package|private|remote].*function\s?(\w+)", local.filteredLine, 1, true);
		var name = mid(local.filteredLine, results.pos[2], results.len[2]);
		return local.name;
	}
	
	/**
	 * This method accepts the current line number in the source file
	 * iteration, and determines how to calculate the difference between
	 * the number of total valid open braces that have been opened minus the 
	 * the number of total valid closed braces.  A "valid" brace is one that
	 * is an actual member of the CFC declaration - NOT one that has been
	 * declared within a string.
	 *
	 * Currently this method is a bit clunky and will need to be refactored
	 * at some point.
	 */
	private numeric function calculateBraceDelta(required string line) {
			
		var open = countMatches("\{", arguments.line);
		var close = countMatches("\}", arguments.line);
		
		/*
		 * This next matcher is intended to extrapolate any strings on this line (values between
		 * single or double-quotes) and see if any braces, open or closed, exist within that
		 * string.  We need to compensate for that by subtracting the number of those string
		 * braces from the actual component definition count.
		 */
		var m = getPattern().compile("[\""|''].+?[\""|'']").matcher(arguments.line);
		
		var subtractOpenBraces = 0;
		var subtractClosedBraces = 0;
		
		while (m.find()) {
			var group = m.group();
			var subtractOpenBraces = countMatches("\{", group);
			var subtractClosedBraces = countMatches("\}", group);
		}
								
		variables.openBraces += (open - subtractOpenBraces);
		variables.closedBraces += (close - subtractClosedBraces);
						
		return variables.openBraces - variables.closedBraces;
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