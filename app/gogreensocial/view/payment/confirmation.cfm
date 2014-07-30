<plait:use layout="secure_layout" />

<head>
	<title>GoGiveSocial - Contribution Confirmation</title>
</head>	

<body>	

<div id="maincontent" class="bodywidth">
	
	<cfoutput>	
	<div id="initiativeleft">							
	<fieldset>	
	<legend>Checkout</legend>
		<cfinclude template="/view/payment/payment.cfm" >
	</fieldset>					
	</div>	

	<div id="cartright">									
		<cfinclude template="/view/payment/cart.cfm" >
	</div>	
	
</cfoutput>
</div>

</body>



