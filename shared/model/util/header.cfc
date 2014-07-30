<cfcomponent>

	<cffunction name="suppressDebugOutput" access="public" returntype="void">
		<cfsetting showdebugoutput="false" />
	</cffunction>
	
	<cffunction name="addStatusCodeHeader" access="public" returntype="void">
		<cfargument name="statusCode" type="numeric" required="true" />
		<cfheader statuscode="#arguments.statusCode#" />
	</cffunction>
	
	<cffunction name="addHeader" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfheader name="#arguments.name#" value="#arguments.value#" />
	</cffunction>
	
</cfcomponent>