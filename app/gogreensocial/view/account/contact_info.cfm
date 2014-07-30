<cfoutput>

<div class="form_control">
	<label for="o:user[firstname]">First Name:</label>
	<input type="text" id="firstname" name="o:user[firstname]" <cfif isdefined("session.user")> value="#session.user.firstname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="o:user[lastname]">Last Name:</label>
	<input type="text" id="lastname" name="o:user[lastname]" <cfif isdefined("session.user")> value="#session.user.lastname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="o:user[email]">Email Address:</label>
	<input type="text" id="email" name="o:user[email]" <cfif isdefined("session.user")> value="#session.user.email()#" </cfif> />			
</div>

<div class="form_control">
	<label for="user[password]">Password:</label>
	<input type="password" id="password" name="o:user[password]" <cfif isdefined("session.user")> value="#session.user.password()#" </cfif> />			
</div>

<div class="form_control">
	<label for="user[verifyPassword]">Verify Password:</label>
	<input type="password" id="verifyPassword" name="o:user[verifyPassword]" />		
</div>

<div class="form_control">
	<label for="o:address[street]">Street address:</label>
	<input type="text" id="street" name="o:address[street]" <cfif isdefined("reply.account") && reply.account.hasAddress() > value="#reply.account.address()[1].street()#" </cfif> />
</div>
	
<div class="form_control">
	<label for="o:address[city]">City:</label>	
	<cfif isdefined("reply.account") && reply.account.hasAddress() >
		<input type="text" name="o:address[city]" value="#reply.account.address()[1].city()#" />		
	<cfelse>
		<input type="text" name="o:address[city]" value="#reply.geoip.city()#" />	
	</cfif>	
</div>			
			
<div class="form_control">
	<label for="o:address[state]">State:</label><br>
	<select name="o:address[state]" id="state">
		<option value=""></option>
		<cfloop array="#reply.region#" index="aState">			
			<cfif isdefined("reply.account") && reply.account.hasAddress() >		
				<option value="#aState.code()#" <cfif aState.name() eq reply.geoip.region().name() > selected</cfif>>#aState.name()#</option>	
			<cfelse>
				<option value="#aState.code()#" <cfif aState.code() eq reply.geoip.region().code() > selected</cfif>>#aState.name()#</option>
			</cfif>	
			
			
		</cfloop>
	</select>
</div>
			
<div class="form_control">
	<label for="o:address[zipcode]">Zip/Postal code:</label>	
	<cfif isdefined("reply.account") && reply.account.hasAddress() >
		<input type="text" name="o:address[zipcode]" value="#reply.account.address()[1].zipcode()#" />		
	<cfelse>
		<input type="text" name="o:address[zipcode]" value="#reply.geoip.postalCode()#" />
	</cfif>		
</div>
</cfoutput>