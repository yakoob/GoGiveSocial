<plait:use layout="no_layout" />
<cfoutput>	
<body>					
<!--- begin credit card --->
<div class="form_control">
	<label for="creditcard_name">Name on card:</label>
	<input type="text" id="creditcard_name" name="creditcard_name" <cfif isdefined("reply.user")> value="#reply.user.firstname()# #reply.user.lastname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="creditcard_bin">Card number:</label>
	<input type="text" id="creditcard_bin" name="creditcard_bin" />			
</div>
	
<div class="form_control">
	<label for="creditcard_expiration">Card expiration:</label>
	<select name="creditcard_expiration_month" id="creditcard_expiration_month">
		<cfloop from="1" to="12" index="ccmonth"><option><cfoutput>#ccmonth#</cfoutput></option></cfloop>				
	</select>
	<select name="creditcard_expiration_year" id="creditcard_expiration_year">
		<cfloop from="#year(now())#" to="2030" index="ccyear"><option><cfoutput>#ccyear#</cfoutput></option></cfloop>				
	</select>								
</div>

<div class="form_control">
	<label for="creditcard_cvv">Card Verification:</label>
	<input type="text" id="creditcard_cvv" name="creditcard_cvv" />			
</div>	
</body>
</cfoutput>

