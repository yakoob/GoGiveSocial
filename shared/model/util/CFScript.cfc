<cfcomponent 
	displayname="CF tags unsupported in CFSCRIPT" 
	hint="CF tags unsupported in CFSCRIPT"
	cfcommons:ioc:singleton="true"
	output=false>

<cffunction access=public name=init returntype=CFScript output=false>
	<cfreturn this>
</cffunction>
	
<cffunction access=public name=cfcookie returntype=void output=false>
	<cfargument name='name' required=true>
	<cfargument name='value'>
  <cfargument name='expires' default="never">
  <cfargument name='domain' default="#cgi.server_name#">  
  <cfargument name='httponly'> 
  <cfargument name='path'> 
  <cfargument name='secure'>
  <cfargument name='attributeCollection' default="#structNew()#"> 
 	<cfscript>
  local.attributeStruct = structNew();
  
  // load arguments.attributeCollection into local.attributeStruct struct
  for ( attributeName in arguments.attributeCollection ) {
  	if ( attributeName != 'attibuteCollection' && !isNull(arguments.attributeCollection[attributeName]) )
  		local.attributeStruct[attributeName] = arguments.attributeCollection[attributeName];
	}
	
	// load explicitly sent attributes into cookieValues struct, overwriteing attributeCollection values from above --->
	for ( local.attributeName in arguments ) {
  	if ( attributeName != 'attributeCollection' && !isNull(arguments[attributeName]) )
  		local.attributeStruct[attributeName] = arguments[attributeName];
	}
	</cfscript>
	
	<!--- set the cookie useing created attributeStruct --->
	<cfcookie attributeCollection = #local.attributeStruct#>
</cffunction>

</cfcomponent>
