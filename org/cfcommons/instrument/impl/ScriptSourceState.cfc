/**
 * This component provides the means to manage the "state" of an
 * iteration through each line of a script-based CFC source file.  Each method
 * will return accurate and relevant information on the state of 
 * the iteration itself - such as whether or not, for the current
 * source line, you're inside of a method declaration or at the beginning
 * of a method declaration.
 */
component implements="org.cfcommons.instrument.SourceState" {

	public ScriptSourceState function init() {
	
		variables.lineCount = 0;
		variables.isEndOfMethod = false;
		variables.previousLine = "";
		variables.currentLine = "";
		variables.braceDelta = 0;
		variables.openBraces = 0;
		variables.closedBraces = 0;
		variables.braceDelta = 0;
		variables.inMethod = false;
	
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
		}
		
		/*
		 * If we're tracking a method AND the open bracket count 
		 * minus the closed bracket count are exactly equal to 1 (inside a CFC will always be 1) 
		 * - method is closed.
		 */
		if (variables.inMethod && variables.braceDelta == 1) {
			variables.inMethod = false;
			variables.isEndOfMethod = true;
			variables.currentMethodName = "";
		}
		
	}
	
	public numeric function getCurrentLineNumber() {
		return variables.lineCount;
	}
	
	public boolean function inScript() {
		return true;
	}
	
	public boolean function inTags() {
		return false;
	}
	
	public boolean function inMethod() {
		return variables.inMethod;
	}
	
	public boolean function atEndOfMethod() {
		return variables.isEndOfMethod;
	}
	
	/**
	 * Will return true if the current source represents actual implementation code.
	 * Empty strings, closing braces terminating a code block, and even property declarations
	 * are not implementation symbols which will result in this method returnig a false.
	 */
	public boolean function inImplementation() {
	
		var line = createObject("java", "java.lang.String").init(variables.currentLine);
		
		if (line.length() == 0) {
			return false;
		}
		
		if (!this.inMethod()) {
			return false;
		}
		
		if (line.matches("^\}$")) {
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
	public numeric function getBraceDelta() {
		return variables.braceDelta;
	}
	
	/**
	 * This method accepts the current line number in the source file
	 * iteration, and determines how to calculate the difference between
	 * the number of total valid open braces that have been opened minus the 
	 * the number of total valid closed braces.  A "valid" brace is one that
	 * is an actual member of the CFC declaration - NOT one that has been
	 * declared within a string.
	 *
	 * Currently this method is a bit clunky and definitely needs to be
	 * refactored.
	 * 
	 * @author Brian Carr
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