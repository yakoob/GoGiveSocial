<plait:use layout="secure_layout" />

<head>
	<title>GoGiveSocial - Contribution Confirmation</title>
</head>	

<body>	
		
<div id="maincontent" class="bodywidth">
	<fieldset>
	<cfoutput>
	<cfif !isnull(reply.initiative)>
		#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary="I just made a donation towards: #reply.initiative.name()# @ #request.app.http##request.app.url#/initiative/#reply.initiative.id()#")#
	<cfelse>	
		#invoke.SocialPlugin().display(infoPath="#reply.app.http##reply.app.url#", summary="Please help with your donation @ #request.app.http##request.app.url#")#
	</cfif>
	</cfoutput>
	</fieldset>	
	<br>
	<cfif request.account.processor neq "Google"><form id="webForm" action="/payment/ledger/process" method="post" style="background-color:##fffffff; padding:0px; margin:0px;"></cfif>
	<cfoutput>	
	<div id="initiativeleft">							
		<fieldset>					
		<legend>Checkout</legend>		
			<cfif request.account.processor eq "Google">
				<h2>This is an example of your Organization's Google Checkout process.</h2>
				<cfset session.GoogleCart =  createObject("component","googlecheckout.components.googlecheckout")>							
				<cfoutput>#session.googleCart.CreateForm()#</cfoutput>						
			<cfelse>					
				<cfinclude template="/view/payment/payment.cfm" >
				<br>	
				<input type="submit" class="donate" value="Confirm #reply.submitButton#" />
			</cfif>
		</fieldset>
	</div>	
	<div id="cartright">									
		<cfinclude template="/view/payment/cart.cfm" >	
						
	</div>
	</cfoutput>		
	<cfif request.account.processor neq "Google"></form></cfif>
</div>

</body>



