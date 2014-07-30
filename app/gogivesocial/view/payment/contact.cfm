<cfoutput>

<div class="form_control">
	<label for="firstname">First Name:</label>
	<input type="text" id="firstname" name="firstname" <cfif isdefined("reply.user")> value="#reply.user.firstname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="lastname">Last Name:</label>
	<input type="text" id="lastname" name="lastname" <cfif isdefined("reply.user")> value="#reply.user.lastname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="email">Email Address:</label>
	<input type="text" id="email" name="email" <cfif isdefined("reply.user")> value="#reply.user.email()#" </cfif> />			
</div>

<div class="form_control">
	<label for="address_street">Street address:</label>
	<input type="text" id="address_street" name="address_street" <cfif isdefined("reply.account") && reply.account.hasAddress() > value="#reply.account.address()[1].street()#" </cfif> />
</div>
	
<div class="form_control">
	<label for="address_city]">City:</label>
	<cfif isdefined("reply.account") && reply.account.hasAddress() >
		<input type="text" name="address_city" value="#reply.account.address()[1].city()#" />		
	<cfelse>
		<input type="text" name="address_city" value="#reply.geoip.city()#" />	
	</cfif>	
</div>

<div class="form_control">
	<label for="address_state">State:</label>
	<select name="address_state" id="address_state">
		<option value=""></option>
		
		
		<cfloop array="#reply.region#" index="aState">			
			<cfif isdefined("reply.account") && reply.account.hasAddress() >		
				<option value="#aState.code()#" <cfif aState.code() eq reply.account.address()[1].state() > selected</cfif>>#aState.name()#</option>	
			<cfelse>
				<option value="#aState.code()#" <cfif aState.code() eq reply.geoip.region().code() > selected</cfif>>#aState.name()#</option>
			</cfif>				
		</cfloop>
	</select>
</div>
			
<div class="form_control">
	<label for="address_zipcode">Zip/Postal code:</label>
	<cfif isdefined("reply.account") && reply.account.hasAddress() >
		<input type="text" name="address_zipcode" value="#reply.account.address()[1].zipcode()#" />		
	<cfelse>
		<input type="text" name="address_zipcode" value="#reply.geoip.postalCode()#" />
	</cfif>		
</div>
</cfoutput>