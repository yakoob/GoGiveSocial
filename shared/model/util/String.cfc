/**
* @accessors true
* @cfcommons:ioc:singleton
*/
component {

	public any function init(){
		return this;
	}

	// CLEAN BETWEEN WORDS WITH SPACE
	private string function toSpace(required string str){
		local.newlist=replace(arguments.str, '%20', ' ', 'all');
		newlist=replace(newlist, '_', ' ', 'all');
		newlist=replace(newlist, '-', ' ', 'all'); 
		return newlist;
	}
	
	// MAKE SPACES BETWEEN WORDS BROWSER FRIENDLY
	private string function fromSpace(required string str){
		local.keyphrase = replace(arguments.str, " ", "%20", "all");
		local.keyphrase = replace(local.keyphrase, "_", "%20", "all");		
		return local.keyphrase;
	}
	
	private string function fromUnderscore(required string str){
		return replace(arguments.str, "_", " ","all");
	}	
	
	private string function toInt(required string str) {
		return replace(arguments.str, ",","","all");
	}
	
	public string function toDash(required string str){
		local.keyphrase = replace(arguments.str, " ", "-", "all");
		keyphrase = replace(keyphrase, "%20", "-", "all");		
		return keyphrase;	
	}

	public string function removeHtml(required string str){
		var res = replace(arguments.str, "<p>", "", "all");
		res = replace(res, "</p>", "", "all");		
		res = replace(res, "<br>", "", "all");
		return res;	
	}	


	public string function baseUrl(required string str){
		var res = replace(arguments.str, "www.", "", "all");
		res = replace(res, "local.", "", "all");		
		res = replace(res, "secure.", "", "all");
		return lcase(res);	
	}	

	
	private string function removeWhiteSpace(required string str){
		return REReplace(arguments.str, "[[:cntrl:]]{2,}",chr(0), "ALL");
	}
	
	private string function textareaFormat(required string str){		
		local.content = REreplace(arguments.str, ">\s+<", ">" & chr(13) & chr(10) & "<", "all");//strip whitespace between tags
		content = REreplace(content, "[\n\r\f]+", chr(13) & chr(10), "all");//condense excessive new lines into one new line
		content = REreplace(content, "\t+", " ", "all");//condense excessive tabs into a single space
		return trim(content);
	}
	
	private string function proper(required string str){
		return REReplace(LCase(arguments.str), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL");
	}	
	
	private string function urlFormat(required string str){
		local.string = toDash(arguments.str);
		return replace(string,"'","","all");
	}	
	
	
				
}	