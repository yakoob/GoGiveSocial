<fieldset>	
<legend>My Contribution</legend>		
<cfif arraylen(reply.cart.items)>				
<cfoutput>
	<cfloop array="#reply.cart.items#" index="i">
		<p><img src="/public/images/icons/ok.png" width="15px"> (#i.quantity#) #i.name# <cfif i.donationType eq "money">#dollarformat(i.cost*i.quantity)#<cfelseif i.assettype eq "people"><font style="color:green">*volunteer*</font><cfelse><font style="color:red;">*gift*</font></cfif></p><br>				
	</cfloop>	
	<cfinclude template="/view/payment/donation_totals.cfm">	
</cfoutput>					
<cfelse>
	No items in your cart...
</cfif>
</fieldset>	