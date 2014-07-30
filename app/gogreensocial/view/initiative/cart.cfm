<plait:use layout="none" />
<body>	

<cfoutput>	
<fieldset>	
<legend>My Contribution</legend>				
<cfif arraylen(reply.cart.items)>
	<br>
	<cfloop array="#reply.cart.items#" index="i">					
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
		<cfif i.assettype neq "people">
			&nbsp;&nbsp;<a href="##" onclick="jsRemoveCartItem('#i.uid#')">
			<img width="20px" src="/public/images/icons/cart_remove.png" title="remove from cart"></a>
		</cfif>			
		</p>						
	</cfloop>
	<br>
	<p><b>Total Amount: #dollarformat(reply.cart.totals.cost)#</b></p>
			
	<p><a href="##" onclick="clearCart()">Clear Cart <img border="0" width="20px"  src="/public/images/icons/cart_remove.png"></a></p>
	<h3><a href="http://#request.app.url#/ledger/donate" class="donate">Confirm Contribution</a></h3>
	
	
<cfelse>
	No items in your cart...
</cfif>				
</fieldset>	
</cfoutput>	

</body>
