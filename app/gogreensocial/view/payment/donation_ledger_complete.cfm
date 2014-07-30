<plait:use layout="secure_layout" />
<cfoutput>
<head>
	<title> - Contribution Confirmation</title>
							
	<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>		
	<script type="text/javascript"> 
	$(document).ready(function() {		 
		$('.workload').workload();			
	});
	</script>				
</head>	
<body>	
<div id="content" style="width:650px">			
	<div class="post">							
		<fieldset>	
		<legend>Contribution Confirmation</legend>
		<p><b>Thank you for your contribution!</b></p> 
		
		<fieldset>	
		<cfif !isnull(reply.initiative)>
			#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary="I just made a contribution towards: #reply.initiative.name()# @ #request.app.http##request.app.url#/initiative/#reply.initiative.id()#")#
		<cfelse>	
			#invoke.SocialPlugin().display(infoPath="#reply.socialUrl#", summary="I just made a contribution @ #request.app.http##request.app.url#")#
		</cfif>
					
		</fieldset>	
		
		<cfif !isnull(reply.initiative)>
			<br>
			<fieldset>											
				<cfset initiative = reply.initiative>
				<cfset iDescribe.statsOnly = false>				
				<cfinclude template="/view/initiative/contribution_summary.cfm" >			
				<br>					
			</fieldset>			
		</cfif>		
		
		</fieldset>				

	</div>								
</div>

<div id="sidebar">
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
</div>

</body>
</cfoutput>
