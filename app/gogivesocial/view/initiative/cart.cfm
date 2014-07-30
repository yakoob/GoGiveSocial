<plait:use layout="none" />
<html>

	<body>	
	<cfoutput>

	<fieldset>	
	<legend>My Contribution</legend>				
	<cfif arraylen(reply.cart.items)>
		<br>
		<cfloop array="#reply.cart.items#" index="i">					
			<p><img src="/public/images/icons/ok.png" width="15px">
			<cfif val(i.quantity)>(#i.quantity#)&nbsp;</cfif>
			#i.name#&nbsp;					
			<cfif i.donationType eq "money">
				#dollarformat(i.cost*i.quantity)#
			<cfelseif i.assettype eq "people">
				<font style="color:green;">*volunteer*</font>
			<cfelse>
				<font style="color:red;">*gift*</font> 
			</cfif> 
			<cfif i.assettype neq "people">
				&nbsp;&nbsp;<a href="##" onclick="jsRemoveCartItem('#i.uid#')">
				<img width="20px" src="/public/images/icons/cart_remove.png" title="remove from cart"></a>
			</cfif>			
			</p>	
			<br>					
		</cfloop>
		<br>
		<p><b>Total Amount: #dollarformat(reply.cart.totals.cost)#</b></p>
		<br><a href="##" onclick="clearCart()" class="findoutmore">clear cart</a>
		<br><a href="<cfif cgi.http_host contains 'local.'>http://#request.app.url#<cfelse>http://#request.app.url#</cfif>/payment/ledger" class="donate">Donate</a>
	<cfelse>
		No items in your cart...
	</cfif>				
	</fieldset>	
	</cfoutput>	
	
	</body>

</html>
