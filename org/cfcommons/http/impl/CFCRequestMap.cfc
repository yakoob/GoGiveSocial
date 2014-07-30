<cfcomponent extends="org.cfcommons.http.impl.SimpleRequestMatcher" 
	implements="org.cfcommons.http.RequestMap">

	<cffunction name="init" access="public" returntype="org.cfcommons.http.RequestMap">
		<cfset super.init() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setObject" access="public" returntype="void">
		<cfargument name="object" type="any" required="true" />
	
		<cfset variables.object = arguments.object />
	</cffunction>
	
	<cffunction name="setClassName" access="public" returntype="void">
		<cfargument name="className" type="string" required="true" />
	
		<cfset variables.className = arguments.className />
	</cffunction>
	
	<cffunction name="setMethodName" access="public" returntype="void">
		<cfargument name="methodName" type="string" required="true" />
		
		<cfset variables.methodName = arguments.methodName />	
	</cffunction>
	
	<cffunction name="mapRequest" access="public" returntype="any">
		<cfargument name="uri" type="string" required="true" />
		<cfargument name="requestData" type="struct" required="true" />
		
		<!--- //
			Grab and bind all relevant request data to 
			the invocation of the mapped method on the provided
			object instance.
		// --->
		<cfset var data = super.getRequestVariables(uri=arguments.uri,
			requestData=arguments.requestData) />
						
		<cfset var args = {} />				
		
		<!--- // set it in the arguments scope but DO NOT overwrite what is already there // --->
		<cfset structAppend(local.args, arguments.requestData) />
		<cfset structAppend(local.args, local.data) />
		<cfset structAppend(local.args, arguments) />
			
		<!--- // make sure that we have either a classname or object instance // --->
		<cfif isNull(variables.className) && isNull(variables.object)>
			<cfthrow type="NullInstanceInvocationException" message="Both the object instance
				and class name have not been set - cannot invoke a method on a non-existent object." />
		</cfif>
		
		<cfset var instance = getInstance() />
		
		<!--- //
			Now bind all other shared scope variables
		// --->
		<cfif !isNull(form)>
			<cfset structAppend(local.args, form) />\
		</cfif>
			
		<cfset structAppend(local.args, url) />
		<cfset structAppend(local.args, request) />
				
		<cfreturn doInvocation(instance=local.instance, methodName=variables.methodName,
			args=local.args) />
	</cffunction>
	
	<cffunction name="doInvocation" access="private" returntype="any">
		<cfargument name="instance" type="any" required="true" />
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		
		<cfinvoke component="#arguments.instance#" method="#arguments.methodName#"
				argumentcollection="#arguments.args#" returnvariable="local.results" />
				
		<!--- // just in case the invocation returns null // --->
		<cfif isNull(local.results)>
			<cfreturn />
		<cfelse>
			<cfreturn local.results />
		</cfif>
		
	</cffunction>
	
	<cffunction name="getInstance" access="private" returntype="any">
		<!--- // are we dealing with a classname or an object instance? // --->
		<cfif !isNull(variables.object) && isObject(variables.object)>
			<cfset var instance = variables.object />
		<cfelseif !isNull(variables.className) && len(trim(variables.className))>
			<!--- // create an instance of the class // --->
			<cfset var instance = createObject("component", variables.className) />
			<!--- // is there an init constructor? // --->
			<cfif structKeyExists(instance, "init") && isCustomFunction(instance.init)>
				<cfset var instance = instance.init() />
			</cfif>
		<cfelse>
			<cfthrow type="AmbigiousInstanceException" message="Neither the object
				or class name variables contain valid data from which to instantiate an object." />
		</cfif>
		<cfreturn local.instance />
	</cffunction>

</cfcomponent>