<plait:use layout="secure_layout" />
<cfoutput>
<head>
	<title>GoGiveSocial - Contribution Confirmation</title>
</head>
<body>	
	<div id="content" style="width:650px">			
		<div class="post">							
			
			<fieldset>						
				<cfif !isnull(reply.initiative)>
				#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary="I just made a donation towards: #reply.initiative.name()# @ #request.app.http##request.app.url#/initiative/#reply.initiative.id()#")#
				<cfelse>	
				#invoke.SocialPlugin().display(infoPath="#request.app.http##request.app.url#", summary="Please help with your donation @ #request.app.http##request.app.url#")#
				</cfif>			
			</fieldset>				
			<br>
						
			<form id="generalDonationForm" action="/payment/cc" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">		
			<fieldset>	
				<legend>Checkout</legend>
				<cfinclude template="/view/payment/payment.cfm" >				
			</fieldset>
			
			<input type="hidden" name="amount" id="amount" value="#reply.cart.totals.cost#">
			<cfif !isnull(reply.initiative.account().id())>
			<input type="hidden" name="accountId" value="#reply.initiative.account().id()#">
			</cfif>							
			<input type="submit" class="donate" value="Confirm #reply.submitButton#" />		
			</form>			
		</div>								
	</div>

	<div id="sidebar">			
		<fieldset>	
			<legend>Donation Summary</legend>	
			<div id="donationTotalsContent"></div>
		</fieldset>						
	</div>
	
	

<script>
	$(document).ready(function() {
		
		$('input[type="submit"]').removeAttr('disabled');	
		$('##paymentError').html("");	
		getTotalHtml();
	
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
		
		$(document).bind('error', function(event, eventObject) {			
			$('input[type="submit"]').removeAttr('disabled');	
			$('.donate').val('Confirm #reply.submitButton#');	
			$('##paymentError').html("<b>Error: " + eventObject.ERRORS[0]) + "</b>";
				
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

		function getTotalHtml(){				
			var uri = '/payment/cc/totals';
			var object = {};
			object.DISPLAYCONTEXT = "donationTotalsContent";	
			object.AMOUNT = "#reply.cart.totals.cost#";		
			$.callMvc(uri,object);	
		}

	});		
		
	
</script>

</body>
</cfoutput>


