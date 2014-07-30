import org.cfcommons.templating.Template;

component extends="org.cfcommons.templating.impl.StringTemplate" {

	public Template function init(required any content) {
	
		super.init(argumentCollection=arguments);
				
		variables.keyValues = {
				"**" = {matcher="[\*]{2}", markup="strong"}
			,	"//" = {matcher="\/{2}", markup="em"}
			,	"=" = {matcher="(?<!\={1})\={1}(?!\={1})", markup="h1"}
			,	"==" = {matcher="(?<!\={1})\={2}(?!\={1})", markup="h2"}
			,	"===" = {matcher="(?<!\={1})\={3}(?!\={1})", markup="h3"}
			,	"====" = {matcher="(?<!\={1})\={4}(?!\={1})", markup="h4"}
			,	"=====" = {matcher="(?<!\={1})\={5}(?!\={1})", markup="h5"}
			,	"======" = {matcher="(?<!\={1})\={6}(?!\={1})", markup="h6"}
			,	"{{{" = {matcher="(?<!\{{3})\{{3}(?!\{{3})", markup="pre", open=true}
			,	"}}}" = {matcher="(?<!\}{3})\}{3}(?!\}{3})", markup="pre", close=true}
			// ,	"---" = {matcher="asdf", markup="hr", terminate=true}
		};
						
		return this;
	}
	
	public string function replace(required struct keyValues) {
						
		// merge the default keyValues with any provided ones
		structAppend(variables.keyValues, arguments.keyValues, true);					
						
		var string = variables.content;
		var markup = "";
						
		for (markup in variables.keyValues) {
			var matcher = variables.keyValues[markup]['matcher'];
			string = replaceWrap(string, markup, matcher);
				
		}
						
		return string;
	}
	
	private string function replaceWrap(required string string, required string markup, 
		required string matcher) {
		
		var finder = ".*" & arguments.matcher & ".*";
		var instruction = variables.keyValues[arguments.markup];
		var tagName = instruction.markup;
							
		while (arguments.string.matches(finder)) {
		
			if (structKeyExists(instruction, "terminate")) {
				arguments.string = arguments.string.replaceFirst(arguments.matcher, 
					getSelfTerminatingTag(tagName));
			} else if (structKeyExists(instruction, "open")) {
				arguments.string = arguments.string.replaceFirst(arguments.matcher, 
					getStartTag(tagName));
			} else if (structKeyExists(instruction, "close")) {
				arguments.string = arguments.string.replaceFirst(arguments.matcher, 
					getEndTag(tagName));
			} else {
				arguments.string = arguments.string.replaceFirst(arguments.matcher, 
					getStartTag(tagName));
				arguments.string = arguments.string.replaceFirst(arguments.matcher, 
					getEndTag(tagName));
			}
		}
		
		return arguments.string;
	}
	
	private string function getStartTag(required string tagName) {
		return "<" & arguments.tagName & ">";
	}
	
	private string function getEndTag(required string tagName) {
		return "</" & arguments.tagName & ">";
	}
	
	private string function getSelfTerminatingTag(required string tagName) {
		return "<" & arguments.tagName & " />";
	}
		
}