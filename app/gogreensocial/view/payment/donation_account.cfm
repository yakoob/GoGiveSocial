<plait:use layout="account" />
<cfoutput>
<head>
	<title>- #reply.title#</title>
</head>
<body>	

	<form id="generalDonationForm" action="http://#request.app.url#/payment/cc" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">
	<div id="content" style="width:500px">			
		<div class="post">										
			<fieldset>	
			#invoke.SocialPlugin().display(infoPath="/#lcase(reply.account.urlPath())#", summary="Please help contribute towards: #reply.account.name()#")#
			</fieldset						
			<br>
					
			<div id="donationleft">							
			<fieldset>	
			<legend>Payment Information</legend>				
				<cfinclude template="/view/payment/payment.cfm" >
			</fieldset>					
			</div>	
			
									
		</div>								
	</div>

	<div id="sidebar" style="width:450px">			
		<fieldset>	
			<legend>Donation</legend>		
			<h2 class="title" style="color:##4086C6;">#reply.account.name()#</h2><cfif len(trim(reply.account.mission()))><i>"#reply.account.mission()#"</i><br><br></cfif>
			
			<b>Pre Selected Level:</b><br>
			
			<select name="psa" id="psa" class="psa">
				<option value="25">$25</option>
				<option value="50">$50</option>
				<option value="75">$75</option>
				<option value="100" selected>$100</option>
				<option value="200">$200</option>
				<option value="500">$500</option>
				<option value="other">Other</option>							
			</select>	
						
			<br><br>
			
			<b>Frequency:</b>
			
			<br><br>
			<input type="radio" name="gf" value="otd" checked> <b>One-time donation:</b><br>
			donation amount: $<input type="text" name="gfotd_value" id="gfotd_value" value="100" style="width:50px">
			
			<br>			
			
			<input type="radio" name="gf" value="rd"> <b>Recurring:</b><br>
			donation amount $<input type="text" name="gfrd_value" id="gfrd_value" value="100" style="width:50px"><select name="gf_value"><option value="monthly">Monthly</option><option value="annually">Annually</option></select>		
					
			<br><br>
			<input type="hidden" name="amount" id="amount" value="100">
			<input type="hidden" name="accountId" value="#reply.account.id()#">			
		
			<div id="donationTotalsContent"></div>
			
			<input type="submit" class="donate" value="Confirm #reply.submitButton#" />		
		</fieldset>	
						
	</div>
	</form>
	
	<script>
	$(document).ready(function() {
			
		$('input[type="submit"]').removeAttr('disabled');	
		$('##paymentError').html("");		
		modifyDonation(100);
		
		$('.psa').change(function() {
			var psaval = $("##psa").val();		
			$('##gfotd_value').val(psaval);
			$('##gfrd_value').val(psaval);
			modifyDonation(psaval);		
			if (psaval == 'other') {
				$('##gfotd_value').focus();
				$('##gfrd_value').val('');
				$('##gfotd_value').val('');
			}
		});	
		
		$('##gfrd_value').keyup(function() {		
			var v = $('##gfrd_value').val();	
			$("##psa").val("other");	
			$('##gfotd_value').val(v);
			modifyDonation(v);
		});	
		
		$('##gfotd_value').keyup(function() {
			var v = $('##gfotd_value').val();	
			$("##psa").val("other");	
			$('##gfrd_value').val(v);
			modifyDonation(v);
		});	
			
		$( '##generalDonationForm' ).submit( function(){		
			$('##paymentError').html("");
			var uri = $( this ).attr( 'action' );
			var object = $( this ).serializeForm();
			object.DISPLAYCONTEXT = '';		
			$('.donate').val('please wait while we process your transaction...');
				$('input[type=submit]', this).attr('disabled', 'disabled');		
			$.callUri(uri,object);									
			return false;		
		});				
		
		$(document).bind('ccPaymentMade', function(event, eventObject) {			
			$('.donate').val('Confirm #reply.submitButton#');
			$('input[type="submit"]').removeAttr('disabled');			
			
			var uri = '/donation/receipt';
			var object = {};
			object.DISPLAYCONTEXT = "page";		
			object.ACCOUNTID = eventObject.ACCOUNTID;		
			object.TRANSACTIONID = eventObject.TRANSACTIONID;
			$.callMvc(uri,object);						
		});		
		
		$(document).bind('error', function(event, eventObject) {				
			$('input[type="submit"]').removeAttr('disabled');	
			$('.donate').val('Confirm #reply.submitButton#');	
			$('##paymentError').html("<b>Error: " + eventObject.ERRORS[0]) + "</b>";				
		});		
		
		
		function modifyDonation(amount){
			$('##amount').val(amount);
					
			displayTotals(amount);
		}		
			
		function displayTotals(amount) {
			var uri = '/payment/cc/totals';
			var object = {};
			object.DISPLAYCONTEXT = "donationTotalsContent";		
			object.AMOUNT = amount;		
			$.callMvc(uri,object);				
		}		
	
	    $("##gfotd_value").keydown(function(event) {	      
	        if ( event.keyCode == 46 || event.keyCode == 8 ) {	            
	        }
	        else {	            
	            if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
	                event.preventDefault(); 
	            }   
	        }
	    });
		
	    $("##gfrd_value").keydown(function(event) {	      
	        if ( event.keyCode == 46 || event.keyCode == 8 ) {	            
	        }
	        else {	            
	            if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
	                event.preventDefault(); 
	            }   
	        }
	    });		
	});	
		 	
	</script>
	
</body>
</cfoutput>
