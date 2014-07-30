/**
* @hint Extracts search keywords from a URL.
* @cfcommons:ioc:singleton
*/ 
component output=false {

	public Keyword function init() {
		return this;
	}
	


	/**
	* @hint Parse the HTTP referrer and extract any keywords that were typed into a search engine.
	*/
	public string function typedInKeywordExtract(required string input=cgi.http_referer) {
		local.keyValuePair = '';
		local.key='';
		local.value = '';
		//use array rather than list because listContains is like a contains, arrayFind gets it right - TM
		local.keyArray = listToArray('as_epq,q,Q,qry,query,p,string,qs,as_q,keywords,qkw,qraw,term,t,searchfor,search,_queryItemFromHeader,eingabe,st');
		local.i = 0;
		local.st = ''; //for look.com st param, which is often not the correct value, prefer q=, see comment below for example
		//	?&st=kwd&searchfor=nomber+boston
		//	?st=Internet+Phone+Service
		
		
		//if ? found, remove ? and all chars to left
		if ( find('?', arguments.input) )
			arguments.input = listRest(arguments.input,'?');
		
		//loop over key/value pairs, delimited by &
		for (i = 1; i<=listLen(arguments.input,'&?'); i++) {
			keyValuePair = listGetAt(arguments.input,i,'&?');
			//writeOutPut(keyValuePair&'<br>');
			//ensure a key & value are present, if not continue loop
			if ( listLen(keyValuePair,'=') != 2 ) {
				continue;
			}
			
			//extract key from keyValue pair
			key = listFirst(keyValuePair,'=');
			
			//if key indicates typedInWord, return value from key/value pair
			if (arrayFind(keyArray, key) != 0) {
				//extract value from keyValue pair
				value = listLast(keyValuePair,'=');
				//extract cache: keywords
				if ( left(value,6) == 'cache:' ) {
					value = listRest(value,'+');
				}
				//clean value
				value = urlDecode(value);
				value = trim(value);
				value = replace(value,'"','','all');
				value = replace(value,"'","",'all');
				value = reReplace(value,'[\[\]\(\)]','','all');
				
				//store value for key st=, but don't stop looping, look for better
				if ( key == 'st' ) {
					st = value;
					continue;
				}
				if ( len(value) )
					break;
			}
		}
		
		//if nothing else available, use value of st=
		if ( !len(value) and len(st) )
			value = st;	
		return value;		
	}

	
	
}