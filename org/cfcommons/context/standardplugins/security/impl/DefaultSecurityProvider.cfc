<cfimport path="org.cfcommons.context.standardplugins.security.*" />

<cfcomponent implements="org.cfcommons.context.standardplugins.security.SecurityProvider">

	<cfset variables.dummyUsers = {} />
	<cfset variables.loginUrl = "" />

	<cffunction name="init" access="public" returntype="DefaultSecurityProvider">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="hasKeys" access="public" returntype="boolean">
		<cfargument name="keynameList" type="string" required="true" />
		
		<cfreturn isUserInAnyRole(arguments.keynameList) />
	</cffunction>
	
	<cffunction name="secure" access="public" returntype="struct">
	
		<!--- // ensure the security expression is a member of the argument collection // --->
		<cfif !structKeyExists(arguments, "expression")>
			<cfthrow type="SecurityException" message="Security Expression Missing"
				detail="The security expression is not a member of the arguments - cannot evaluate."
				extendedInfo="#variables.loginURL#" />
		</cfif>
	
		<!--- // evaluate the expression - it must return true // --->
		<cfif !evaluate(arguments.expression)>
			<cfthrow type="SecurityException" message="Access Denied"
				detail="Access is denied to the requested resource." 
				extendedInfo="#variables.loginURL#" />
		</cfif>
	
		<!--- // make sure to return the runtime arg collection in its original state // --->
		<cfreturn arguments />	
	</cffunction>
	
	<cffunction name="login" access="public" returntype="boolean">
	
		<cfif !structKeyExists(form, "cfcommons_security_username")>
			<!--- // no message or detail // --->
			<cfthrow type="SecurityException" extendedInfo="#variables.loginURL#" />
		</cfif>
						
		<!--- // use default coldfusion security framework to log us in // --->
		
		<!--- // is there a dummy user we can use? // --->
		<cfif structKeyExists(variables.dummyUsers, form.cfcommons_security_username) && 
			variables.dummyUsers[form.cfcommons_security_username].getPassword() eq hash(form.cfcommons_security_password)>
			<cfset var user = variables.dummyUsers[form.cfcommons_security_username] />
		<cfelse>
			<!--- // sorry, login unsuccessful // --->
			<cfreturn false />
		</cfif>
		
		<cflogin>
		    <cfloginuser
				name="#form.cfcommons_security_username#" 
		        password="#form.cfcommons_security_password#" 
		        roles="#user.getKeys()#" /> 
		</cflogin>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="isLoggedIn" access="public" returntype="boolean">
		<cfreturn isUserLoggedIn() />	
	</cffunction>
	
	<cffunction name="logout" access="public" returntype="boolean">
		<!--- // using the standard CF application security framework here // --->
		<cflogout />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="addDummyUser" access="public" returntype="void">
		<cfargument name="user" type="DummyUser" required="true" />
		<cfset variables.dummyUsers[arguments.user.getUsername()] = arguments.user />
	</cffunction>
	
	<cffunction name="setLoginURL" access="public" returntype="void">
		<cfargument name="url" type="string" required="true" />
		<cfset variables.loginUrl = arguments.url />
	</cffunction>
	
</cfcomponent>