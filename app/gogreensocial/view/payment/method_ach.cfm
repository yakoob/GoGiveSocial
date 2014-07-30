<plait:use layout="no_layout" />

<cfoutput>	
<body>					

<!--- begin ACH --->
<div class="form_control">
	<label for="ach_name">Name on Account:</label>
	<input type="text" id="ach_name" name="ach_name" <cfif isdefined("reply.user")> value="#reply.user.firstname()# #reply.user.lastname()#" </cfif> />			
</div>

<div class="form_control">
	<label for="ach_routing">Routing Number:</label>
	<input type="text" id="ach_routing" name="ach_routing" />			
</div>
	
<div class="form_control">
	<label for="ach_account">Account Number:</label>
	<input type="text" id="ach_account" name="ach_account" />			
</div>	

<div class="form_control">							
	<label>Electronic Signature:</label>				
	<blockquote style="width:25%; margin-left:15%; font-size: x-small; font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;">				
	<input type="checkbox" name="ach_signature"/> 
	I/we hereby agree to comply with GoGreenSocial's requirements for the ACH Credit Payment method.  I/we also
	authorize GoGreenSocial's to update our payment method to ACH Debit if I/we repeatedly fail to correctly complete the
	payment transactions in accordance with the required procedures set forth by GoGreenSocial.
	</blockquote>		
</div>						
<!--- end ACH --->
</body>
</cfoutput>


