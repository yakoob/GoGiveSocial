component extends="org.cfcommons.faceplait.impl.BasicView" implements="org.cfcommons.faceplait.Page" {

	public HTMLPage function init(string filePath, struct pageVars=structNew()) {
		if (!isNull(arguments.filePath))
			parseContents(arguments.filePath, arguments.pageVars);
		return this;
	}
	
	public string function getTitleContent() {
		var results = rematch("<title>([\S\<\>\:\s]*)</title>", getContents());
		
		if (!arrayLen(results))
			return "";
		
		// strip out the title tags - for some reason, rematch won't let us do that
		results = rereplaceNoCase(results[1], "<title>|<\/title>", "", "all");
		
		return results;
	}
	
	public string function getHeadContent() {
		var results = rematch("<head>([\S\<\>\:\s]*)</head>", getContents());
		
		if (!arrayLen(results))
			return "";
			
		// time to get rid of any title tags that might exist
		results = rereplaceNoCase(results[1], "<title>([\S\<\>\:\s]*)</title>", "", "all");
		
		// strip out the title tags - for some reason, rematch won't let us do that
		results = rereplaceNoCase(results, "<head>|<\/head>", "", "all");
		
		return results;
	}
	
	public string function getBodyContent() {
		var results = rematch("<body>([\S\<\>\:\s]*)</body>", getContents());
		
		if (!arrayLen(results))
			return "";
		
		// strip out the title tags - for some reason, rematch won't let us do that
		results = rereplaceNoCase(results[1], "<body>|<\/body>", "", "all");
		
		return results;
	}
	
	public boolean function hasLayoutMarker() {
		return refindNoCase("\<plait\:use\s+layout", getContents(), 1, false) ? true : false;
	}
	
	public string function getLayoutName() {
		var string = rematchNoCase("\<plait\:use\s+layout\s?=\s?[""|'']\s?([\w-_]*)\s?[""|'']", getContents());
		
		// do we have a winner?
		if (!arrayLen(string))
			return "";
			
		// refine the string
		var string = rematch("[""|'']\s?([\w-_]*)\s?[""|'']", string[1]);
		var string = rereplace(string[1], "[""|'']", "", "all");
		
		return string;
	}

}