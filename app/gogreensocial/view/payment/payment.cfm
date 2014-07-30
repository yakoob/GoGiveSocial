<cfoutput>


	
	<fieldset>	
	<div id="paymentError" style="color:red;"></div>
	<!--- 
	<legend>Payment Method</legend>
	<div class="form_control">														
		<input type="radio" data-id="paymentMethod" name="payment_method" value="creditcard" rel="/payment/method/creditcard" checked/> Credit Card
		<input type="radio" data-id="paymentMethod" name="payment_method" value="ach" rel="/payment/method/ach"  /> Electronic Check								
	</div>
	--->	
	<input type="hidden" name="payment_method" value="creditcard">
		
	<div id="form_paymentMethod">	
	<cfinclude template="/view/payment/method_creditcard.cfm" />
	</div>
	</fieldset>
	
	
		
	<cfif !isnull(reply.user)>
	<br>
	<fieldset>
	<div class="form_control">							
		<label><cfif !isnull(reply.totals.cost) && val(reply.totals.cost)>Billing</cfif> Info:</label>								
		<cfif !isnull(reply.hasLogin)>
			<input type="checkbox" name="contact_use_account" id ="contact_use_account" value="true"  checked="checked"/> Same as Account Info
		</cfif> 				
	</div>		
	</fieldset>
	</cfif>
	
	<br>
	<fieldset>
	

	<cfif !isnull(reply.cart.totals.cost) && val(reply.cart.totals.cost)>
		<legend>Billing Info</legend>	
		<cfinclude template="/view/payment/contact_billing.cfm" />
	<cfelse>
		<legend>Info</legend>	
		<cfinclude template="/view/payment/contact_billing.cfm" />
	</cfif>
	</fieldset>
	
	
	<!--- 
	<script type="text/javascript">		
		$(document).ready(function(){							
			$('input:radio[data-id=paymentMethod]').click( function(){				
				var paymentMethod = $(this + ':checked').val();	
				var uri = $( this ).attr( 'rel' );
				var displayContext = 'form_paymentMethod';					
				var object = {DISPLAYCONTEXT:displayContext, PAYMENTMETHOD:paymentMethod};
				$.callUri(uri,object);
				
			});
		});			
					 	
	</script>		
	--->
</cfoutput>
