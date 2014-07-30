<cfif !isnull(reply.cart.totals.cost) && val(reply.cart.totals.cost)>
<cfoutput>
	<b>Donation Total: #dollarformat(reply.cart.totals.cost)#</b><br><br>
	<!---  TODO: add this back after payment processor setup
	<b>Fee: <cfset fee = (reply.cart.totals.cost * .07)> #dollarformat(fee)#</b><br><br>
	<h3><u>Total: <cfset total = fee+reply.cart.totals.cost>#dollarformat(total)#</u></h3>
	--->
</cfoutput>
</cfif>