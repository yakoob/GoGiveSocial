<cfcomponent>

	<cffunction name="init" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="run" access="public" returntype="any">
		
		<cfset local.results = {} />
									
		<cfif isObject(arguments._instance)>
			<cfinvoke component="#arguments._instance#" method="#arguments._methodName#"
				argumentcollection="#arguments#" returnvariable="local.results" />				
		<cfelseif isCustomFunction(arguments._instance)>
			<cfset local.results = evaluate("arguments._instance(argumentCollection=arguments)") />
		<cfelse>
			<cfthrow type="UnknownAspectType" message="Cannot apply an aspect to an aspect 
				instance that is not an object." />
		</cfif>
										
		<cfreturn isNull(local.results) ? '' : local.results />
	</cffunction>

</cfcomponent>