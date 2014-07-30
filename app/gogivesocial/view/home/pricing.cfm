<plait:use layout="layout" />
<head>
	<title> - Price</title>				
</head>
	
<body>

<div id="maincontent" class="bodywidth">
	<!--- 
		
		Basic
		Premium 
	--->
	<cfsavecontent variable="ok"><img src="/public/images/icons/ok.png" width="15px"></cfsavecontent>
	<cfsavecontent variable="no"><img src="/public/images/icons/cancel.png" width="15px"></cfsavecontent>	
	<form id="prcingForm" name="prcingForm" action="http://<cfoutput>#request.app.url#</cfoutput>/payment/account" method="post" >	
		<fieldset>
		<legend>Pricing - Account Types</legend>	
		<table width="100%" cellpadding="2px" cellspacing="15px" >
		
			<tr valign="top" align="center">
				<td width="40%">&nbsp;</td>				
				<td width="15%"><b>Premium</b><br>(SaaS - Hosted)</td>
				<td width="15%"><b>Custom Brand</b><br>(SaaS - Hosted)</td>
				<td width="15%"><b>Fully Purchased</b></td>
			</tr>
			<cfoutput>
			<tr>
				<td><b>Profile</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Initiatives</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>			
			<tr>
				<td><b>Blogs</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>Partners</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Notification Emails</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>Photos / Videos</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>				
			<tr>
				<td><b>Social Sharing</b> <span style="font-size:10px;">We integrate with all the popular social networks so visitors can easily share their experience while keeping your would-be contributors focused on your Initiative.</span></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Tracked Assets</b> <span style="font-size:10px;">Asset(s) outline the People, Material, and Places needed to accomplish your Initiative. Show exactly what is needed to accomplish your Initiative.</span></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Flexible Widget</b> <span style="font-size:10px;">Place this widget on any webpage to direct visitors to your Initiative</span></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>			
			<tr>
				<td><b>Charting / Reports</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>API / Data Export</b></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>												

			
			<tr>
				<td><b>Payment Processing</b> <span style="font-size:10px;">We will help your organization setup and seamlessly integrate Google Checkout so that you can accept donations online.</span></td>				
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>	
				<td align="center">#ok#</td>
			</tr>				
			
			<tr>
				<td><b>Brand Your Interface</b> <span style="font-size:10px;">We will make the platform look and feel match your current website.</span></td>				
				<td align="center">#no#</td>
				<td align="center">#ok#</td>	
				<td align="center">#ok#</td>
			</tr>		

			<tr>
				<td><b>Fully Purchased</b> <span style="font-size:10px;">Full Access to source code & 8 hours of engineer time to assist with your deployment / integration</span></td>				
				<td align="center">#no#</td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>
			</tr>		

			<tr>
				<td>&nbsp;</td>				
				<td align="center"><h3>3% Transaction Fee</h3></td>
				<td align="center"><h3>2% Transaction Fee plus $99/mo.</h3></td>
				<td align="center"><h3>$35k</h3> <b>(one-time fee)</b></td>
			</tr>				
			<tr>
				<td></td>				
				<td align="center"><input type="radio" name="accounttype" value="premium"  checked="checked"></td>
				<td align="center"><input type="radio" name="accounttype" value="custom"></td>
				<td align="center"><input type="radio" name="accounttype" value="full"></td>
			</tr>	

			</cfoutput>
		</table>
		
		<a href="javascript:document.prcingForm.submit();" title="Find Out More" class="findoutmore" style="width:98%;text-align:center;font-size:1.4em;">Sign Me Up!</a>
		
		</fieldset>		
			
		
	

	
</div>

<script>
	$(document).ready(function(){
		var uri = '/featured/nonprofit';		
		var displayContext = 'display_featured_non_profit';					
		var object = {DISPLAYCONTEXT:displayContext};
		$.callMvc(uri,object);		
	});		
</script>

</body>


<!---
<plait:use layout="layout" />
<head>
	<title> - Price</title>				
</head>
	
<body>

<div id="maincontent" class="bodywidth">
	
	<cfsavecontent variable="ok"><img src="/public/images/icons/ok.png" width="15px"></cfsavecontent>
	<cfsavecontent variable="no"><img src="/public/images/icons/cancel.png" width="15px"></cfsavecontent>	
	<form id="prcingForm" name="prcingForm" action="https://www.gogivesocial.com/payment/account" method="post" >
	
		<fieldset>
		<legend>Pricing - Account Types</legend>	
		<table width="100%" cellpadding="2px" cellspacing="15px" >
		
			<tr valign="top" align="center">
				<td width="40%">&nbsp;</td>
				<td width="15%"><b>Basic</b><br>(SaaS - Hosted)</b></td>
				<td width="15%"><b>Premium</b><br>(SaaS - Hosted)</td>
				<td width="15%"><b>Custom Brand</b><br>(SaaS - Hosted)</td>
				<td width="15%"><b>Fully Purchased</b></td>
			</tr>
			<cfoutput>
			<tr>
				<td><b>Profile</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Initiatives</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>			
			<tr>
				<td><b>Blogs</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>Partners</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Notification Emails</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>Photos / Videos</b></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>				
			<tr>
				<td><b>Social Sharing</b> <span style="font-size:10px;">We integrate with all the popular social networks so visitors can easily share their experience while keeping your would-be contributors focused on your Initiative.</span></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Tracked Assets</b> <span style="font-size:10px;">Asset(s) outline the People, Material, and Places needed to accomplish your Initiative. Show exactly what is needed to accomplish your Initiative.</span></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>
			<tr>
				<td><b>Flexible Widget</b> <span style="font-size:10px;">Place this widget on any webpage to direct visitors to your Initiative</span></td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>			
			<tr>
				<td><b>Charting / Reports</b></td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>	
			<tr>
				<td><b>API / Data Export</b></td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>
			</tr>												

			
			<tr>
				<td><b>Google Checkout Integration</b> <span style="font-size:10px;">We will help your organization setup and seamlessly integrate Google Checkout so that you can accept donations online.</span></td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>
				<td align="center">#ok#</td>	
				<td align="center">#ok#</td>
			</tr>				
			
			<tr>
				<td><b>Brand Your Interface</b> <span style="font-size:10px;">We will make the platform look and feel match your current website.</span></td>
				<td align="center">#no#</td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>	
				<td align="center">#ok#</td>
			</tr>		

			<tr>
				<td><b>Fully Purchased</b> <span style="font-size:10px;">Full Access to source code & 8 hours of engineer time to assist with your deployment / integration</span></td>
				<td align="center">#no#</td>
				<td align="center">#no#</td>
				<td align="center">#no#</td>
				<td align="center">#ok#</td>
			</tr>		

			<tr>
				<td>&nbsp;</td>
				<td align="center"><h2>Free</h2></td>
				<td align="center"><h2>$99/mo.</h2></td>
				<td align="center"><h2>$350/mo.</h2></td>
				<td align="center"><h2>$25k</h2> <b>(one-time fee)</b></td>
			</tr>				

			<tr>
				<td></td>
				<td align="center"><input type="radio" name="accounttype" value="basic" checked="checked"></td>
				<td align="center"><input type="radio" name="accounttype" value="premium"></td>
				<td align="center"><input type="radio" name="accounttype" value="custom"></td>
				<td align="center"><input type="radio" name="accounttype" value="full"></td>
			</tr>	

			</cfoutput>
		</table>
		
		<a href="javascript:document.prcingForm.submit();" title="Find Out More" class="findoutmore" style="width:98%;text-align:center;font-size:1.4em;">Sign Me Up!</a>
		
		</fieldset>		
			
	
</div>

<script>
	$(document).ready(function(){
		var uri = '/featured/nonprofit';		
		var displayContext = 'display_featured_non_profit';					
		var object = {DISPLAYCONTEXT:displayContext};
		$.callMvc(uri,object);		
	});		
</script>

</body>



--->

