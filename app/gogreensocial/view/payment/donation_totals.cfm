<plait:use layout="none" />
<body>

<cfoutput>
<cfif isdefined("session.cart.items")>
<cfif arraylen(session.cart.items)>
	<br>
	<cfloop array="#session.cart.items#" index="i">					
		<p><img src="/public/images/icons/ok.png" width="15px">
		<cfif val(i.quantity)>(#i.quantity#)&nbsp;</cfif>
		<span>#i.name#</span>					
		<cfif i.donationType eq "money">
			#dollarformat(i.cost*i.quantity)#
		<cfelseif i.assettype eq "people">
			<span style="color:green;">*volunteer*</span>
		<cfelse>
			<span style="color:red;">*gift*</span> 
		</cfif>		
		</p>						
	</cfloop>
	<br>
</cfif>
</cfif>	
<b>SubTotal: #dollarformat(reply.amount)#</b><br><br>
<b>Fee: #dollarformat(reply.fee)#</b><br><br>
<h3><u>Total: #dollarformat(reply.total)#</u></h3>	
</cfoutput>
<br>
</body>


