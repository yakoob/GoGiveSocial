<plait:use layout="no_layout" />
<cfoutput>	
<body>					
<!--- begin credit card --->
<div class="form_control">
	<label for="creditcard_name">Name on Card:</label>
	<input type="text" id="creditcard_name" name="creditcard_name" <cfif isdefined("reply.user")> value="#reply.user.firstname()# #reply.user.lastname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="card">Card Number:</label>
	<input type="text" id="card" name="card" />			
</div>
	
<div class="form_control">
	<label for="month">Card Expiration:</label>
	<select name="month" id="month">
		<cfloop from="1" to="12" index="ccmonth"><option><cfoutput>#ccmonth#</cfoutput></option></cfloop>				
	</select>
	<select name="year" id="year">
		<cfloop from="#year(now())#" to="2030" index="ccyear"><option><cfoutput>#ccyear#</cfoutput></option></cfloop>				
	</select>								
</div>

<div class="form_control">
	<label for="cvv">Card Verification:</label>
	<input type="text" id="cvv" name="cvv" />			
</div>	
</body>
</cfoutput>

