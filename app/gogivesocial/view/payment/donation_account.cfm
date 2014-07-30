<plait:use layout="secure_layout" />

<head>
	<title>- <cfoutput>#reply.title#</cfoutput></title>
</head>	

<body>	
<div id="maincontent" class="bodywidth">
	<cfoutput>		

	<fieldset>	
	#invoke.SocialPlugin().display(infoPath="/account/#reply.account.id()#/donate", summary="Please help contribute towards: #reply.account.name()#")#
	</fieldset>			

	<br>
	
	
	
	<cfif request.account.processor eq "Google">

			<fieldset>	
			
			<h2 style="color:red">This is an example of your Organization's Google Checkout process.</h2>
			<br>
			<legend>Donation</legend>				
			<h2 class="title" style="color:##4086C6;">#reply.account.name()#</h2><cfif len(trim(reply.account.mission()))><i>"#reply.account.mission()#"</i><br><br></cfif>		

			<div class="form_control">
				<label for="psa">Pre Selected Level</label>
				<select name="psa" id="psa">
					<option value="25">$25</option>
					<option value="50">$50</option>
					<option value="75">$75</option>
					<option value="100" selected>$100</option>
					<option value="200">$200</option>
					<option value="500">$500</option>
					<option value="other">Other</option>							
				</select>	
			</div>	
			<div class="form_control">
				<label for="gf">Donation Frequency:</label>
				<input type="radio" name="gf" value="otd" checked> <b>One-time donation for the following amount:</b><br>
				enter donation amount: $<input type="text" name="gfotd_value" value="100" style="width:50px">
				<br>
				<input type="radio" name="gf" value="rd"> <b>Recurring gift for the following amount and frequency:</b>
				donation amount $<input type="text" name="gfrd_value" value="100"  style="width:50px"><select name="gf_value"><option value="monthly">Monthly</option><option value="annually">Annually</option></select>		
			</div>		
			<br>					
				<cfset session.GoogleCart =  createObject("component","googlecheckout.components.googlecheckout")>							
				<cfoutput>#session.googleCart.CreateForm()#</cfoutput>		
					
			</fieldset>	
	
			
	<cfelse>
	
		<form id="webForm" action="http://#request.app.url#/payment/account/process" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">
			
		<div id="donationleft" style="height:100%;">		
			<fieldset>	
				<legend>Payment Information</legend>
				<cfinclude template="/view/payment/payment.cfm" >
			</fieldset>						
		</div>
			 	
		<div id="donationright">	
			<fieldset>	
			<legend>Donation</legend>				
			<h2 class="title" style="color:##4086C6;">#reply.account.name()#</h2><cfif len(trim(reply.account.mission()))><i>"#reply.account.mission()#"</i><br><br></cfif>		
			<div class="form_control">
				<label for="psa">Pre Selected Level</label>
				<select name="psa" id="psa">
					<option value="25">$25</option>
					<option value="50">$50</option>
					<option value="75">$75</option>
					<option value="100" selected>$100</option>
					<option value="200">$200</option>
					<option value="500">$500</option>
					<option value="other">Other</option>							
				</select>	
			</div>	
			<div class="form_control">
				<label for="gf">Donation Frequency:</label>
				<input type="radio" name="gf" value="otd" checked> <b>One-time donation for the following amount:</b><br>
				enter donation amount: $<input type="text" name="gfotd_value" value="100" style="width:50px">
				<br>
				<input type="radio" name="gf" value="rd"> <b>Recurring gift for the following amount and frequency:</b>
				donation amount $<input type="text" name="gfrd_value" value="100"  style="width:50px"><select name="gf_value"><option value="monthly">Monthly</option><option value="annually">Annually</option></select>		
			</div>		
			<br>	
			<input type="hidden" name="accountId" value="#reply.account.id()#">
			<input type="submit" class="donate" value="Confirm #reply.submitButton#" />			
			</fieldset>	
		</div>		
		</form>
	</cfif>
</cfoutput>
</div>

</body>



