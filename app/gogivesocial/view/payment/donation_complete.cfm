
<plait:use layout="layout" />
<html>
	<head>
		<title> - Contribution Confirmation</title>			
	</head>	
<body>	

<br>

<cfif !isnull(reply.org)><cfsavecontent variable="orgInfo"><cfoutput>I just made a contribution to: #reply.org.name()#</cfoutput></cfsavecontent></cfif>
<div id="maincontent" class="bodywidth">
<cfoutput>
	<div id="aboutleft">
		<fieldset>	
		<legend>Contribution Confirmation</legend>
		<p><b>Thank you for your contribution!</b></p> 		
		<cfif !isnull(reply.org)>		
		#invoke.SocialPlugin().display(infoPath="/account/#reply.org.id()#/donate", summary=orgInfo)#							
		</cfif>					
		</fieldset>				
	</div>

	<section id="articlesright">		
		<fieldset>	
		<legend>My Contribution</legend>				
		<article>							
			<cfloop array="#reply.cart.items#" index="i">
				<p><img src="/public/images/icons/ok.png" width="15px"> (#i.quantity#) #i.name# <cfif i.donationType eq "money">#dollarformat(i.cost*i.quantity)#<cfelseif i.assettype eq "people"><font style="color:green">*volunteer*</font><cfelse><font style="color:red;">*gift*</font></cfif></li></p>
				<br>				
			</cfloop>	
			<cfinclude template="/view/payment/donation_totals.cfm">
		</article>
	</fieldset>	
	</section>
	
</cfoutput>

</div>	

</body>
</html>