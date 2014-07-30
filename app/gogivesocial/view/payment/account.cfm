<plait:use layout="secure_layout" />

<head>
	<title> - Account Plan Checkout</title>
</head>	

<body>	

<div id="maincontent" class="bodywidth">
	
	<cfoutput>	
	<div id="initiativeleft">							
	<fieldset>	
		<legend>Checkout</legend>		
	
		<cfinclude template="/view/payment/payment.cfm" >
		<br>

		<fieldset>	
		<legend>Account Type</legend>
		<div class="form_control">							
			<blockquote>							
			<input data-id="accountType" type="radio" name="po:account[type]" value="Organization" rel="/account/type/organization" checked="checked"  /> a non-profit organization?<br />
			<input data-id="accountType" type="radio" name="po:account[type]" value="Education" rel="/account/type/education" /> an education institution? <br />
			<input data-id="accountType" type="radio" name="po:account[type]" value="Company" rel="/account/type/company" /> a company?<br />
			<!---<input data-id="accountType" type="radio" name="po:account[type]" value="Individual" rel="/account/type/individual" /> a individual?--->			
			</blockquote>		
		</div>
		<br>
		<div id="form_accountType">
		<cfinclude template="/view/account/type_organization.cfm" />
		</div>	
		
		
		</fieldset>	
	<br>
	<cfinclude template="/view/payment/account_cart.cfm" >
	
	<br>
	<a href="javascript:document.paymentForm.submit();" title="Find Out More" class="findoutmore" style="width:98%;text-align:center;font-size:1.4em;">Confirm Payment</a>
	
	</fieldset>					
	
	
	</div>	

	<div id="cartright">									
		<cfinclude template="/view/payment/account_cart.cfm" >
	</div>	

	<script type="text/javascript">
		$(document).ready(function(){
		
			$( '##webForm' ).submit( function(){
				var obj = $( this ).serializeForm();	
				var uri = $( this ).attr( 'action' );
				
				obj.DISPLAYCONTEXT = 'page';										
				$.callUri(uri,obj);
				return false;
			});			
														
			$('input:radio[data-id=accountType]').click( function(){				
				var accountType = $(this + ':checked').val();	
				var uri = $( this ).attr( 'rel' );
				var displayContext = 'form_accountType';					
				var object = {DISPLAYCONTEXT:displayContext, ACCOUNTTYPE:accountType};
				$.callUri(uri,object);					
			});
			/*
			$(document).bind('accountCreated', function(event, eventObject) {					
				var uri = '/email/verify';	
				var displayContext = 'page';		
				var object = {DISPLAYCONTEXT:displayContext};
				$.callMvc(uri,object);
			});				
			*/
		});						     						 
	</script>		

	
</cfoutput>
</div>

</body>



