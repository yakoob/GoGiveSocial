<cfif !isnull(reply.cart.totals.cost) && val(reply.cart.totals.cost)>
<cfoutput>
	<b>Total: #dollarformat(reply.cart.totals.cost)# <cfif reply.plan NEQ "full">/mo.</cfif></b><br><br>	
</cfoutput>
</cfif>