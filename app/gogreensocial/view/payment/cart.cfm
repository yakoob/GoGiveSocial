<div id="sidebar">
<cfoutput>		

<fieldset>	
<legend>My Contribution</legend>		
<cfif arraylen(reply.cart.items)>				
<cfoutput>
	<cfinclude template="/view/payment/donation_totals.cfm">	
</cfoutput>					
<cfelse>
	No items in your cart...
</cfif>
</fieldset>	
		
</cfoutput>

</div>
