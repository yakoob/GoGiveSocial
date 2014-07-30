/**
* @displayname PageRank
* @extends shared.model.Object
* @cfcommons:ioc:singleton
*/
component {
	
	public PageRank function init(){
		super.init();
		variables.java = {};
			variables.java.Url = CreateObject("java", "java.net.URL").Init(JavaCast("string","file:#application.jarroot#PageRank.jar" ));
			variables.java.ArrayCreator = CreateObject("java", "java.lang.reflect.Array");			
			variables.java.URLArray = java.ArrayCreator.NewInstance(java.Url.GetClass(), JavaCast("int", 1));
			variables.java.ArrayCreator.Set(java.URLArray, JavaCast("int", 0), java.Url);
			variables.java.ClassLoader = createObject("java", "java.net.URLClassLoader").init(java.URLArray);		
			variables.java.pr = createObject("java", "coldfusion.runtime.java.JavaProxy").init(java.ClassLoader.LoadClass("com.temesoft.google.pr.PageRankService"));					
		return this;
	}
	
	/**
	* @output true
	* @hint: input string e.g. "mydomain.com"
	*/
	private string function googleUrl(required string str){	
		return variables.java.pr.getPR(ARGUMENTS.str);		
	}
	
	/**
	* @hint I return a page rank based on input url (e.g. "mydomain.com")
	*/
	public string function google( required string url ){
		local.res = "";		
		// get the raw results from Google
		var httpService = new HTTP();
		httpService.setURL( googleUrl(trim(arguments.url)) );
		var results = httpService.send().getPrefix().filecontent;		
		// results are coming back e.g. 'Rank_1:1:4'; we just want the last number
		if (left( results, 5 )=="Rank_")
			return listlast( results,":" );
		else 
			return "N/A";				
	}
	
}
 