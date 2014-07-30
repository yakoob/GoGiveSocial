<plait:use layout="layout" />

<cfoutput>
<head>
	<title> - #reply.title#</title>	
</head>

<body>		

	<div id="maincontent" class="bodywidth">
		<!---
		<fieldset>	
		#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary=reply.initiative.name())#	
		</fieldset>
		--->
	
		<br>	
		<div id="initiativeleft">	
			<fieldset>	
			<legend>#reply.initiative.name()#</legend>
			<table width="100%">
				<tr>
					<td>									
					<p class="meta"><img src="/public/images/icons/app_48.png" height="20px"> <b>Material (#dollarformat(reply.initiative.ledger().getMaterialTotalDallorBoon())# / #dollarformat(reply.initiative.ledger().getMaterialTotalDallor())#)</b></p>			
					<table align="left" width="100%" cellspacing="2" cellpadding="4">				
						<tr>
						<th></th>													
						<th>Item Cost</th>
						<th>Qty.</th>
						<th>Item</th>
						<th></th>
						</tr>
						<cfloop array="#reply.initiative.ledger().assets()#" index="asset">					
						<cfif listlast(getmetadata(asset).name, ".") is "Material">								
						<form name="frm_addMaterial#asset.id()#" id="frm_addMaterial#asset.id()#" action="/ledger/cart/add" method="post">
						<tr>
							<td><img src="/public/images/icons/circle_blue.png" width="15px"> </td>						
							<td>#dollarformat(asset.getCost())#</td>
							<td>
							<select name="quantity" id="donationQuantity_#asset.id()#">
								<cfloop index="i" from="1" to="#asset.getQuantity()#">
								<option>#i#</option>
								</cfloop>
							</select>
							</td>									
							<td>#asset.getName()#</td>
							<td>
								<select name="type" id="donationType_#asset.id()#">
									<option value="money">Donate Money</option>
									<option value="gift">Donate as Gift</option> 
								</select>	
							</td>		
							<td>							
								<input type="hidden" name="assetID" value="#asset.id()#">
								<a href='##' onclick='$("##frm_addMaterial#asset.id()#").trigger("submit")' class='findoutmore'>Add Cart</a>
							</td>									
						</tr>
						</form>
						</cfif>				
						<script>					
							$( '##frm_addMaterial#asset.id()#' ).submit( function(){							
								var uri = $( this ).attr( 'action' );
								var object = $( this ).serializeForm();
								object.initiativeId = '#reply.initiative.id()#';
								object.DISPLAYCONTEXT = 'fpp';		
								$.callUri(uri,object);																	
								<cfif request.browser EQ "suck">
									window.setTimeout(loadCart, 500, true);										
								</cfif>													
								return false;		
							});						
						</script>								
						</cfloop>																				
					</table>	

					</td>
					
				</tr>
				
				<tr>
					<td>
	
					
					<p><img src="/public/images/icons/users_two_add_48.png" height="20px"> <b>People</b></p>			
					<table align="left" width="100%" cellspacing="2" cellpadding="4">					
						<tr>																											
							<th></th>
							<th>Volunteer</th>
							<th align="left">Job Description</th>
							<th>Target Date</th>					
						</tr>												
						<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
						<cfif listlast(getmetadata(asset).name, ".") is "People">													
						<form id="frm_addPeople" action="/ledger/cart/add" method="post">
						<cfloop array="#session.cart.items#" index="ii">
							<cfif ii.assetid eq asset.id()>
							<cfset hasCheck = true>
							</cfif>
						</cfloop>
						<tr>
							<td align="center"><img src="/public/images/icons/circle_blue.png" width="15px"> </td>									
							<td align="center">
								(#reply.initiative.ledger().getTotalVolunteerBoon()#/#reply.initiative.ledger().getTotalVolunteer()#)<br>
								<input type="checkbox" onclick="toggelPeople(#asset.id()#,this.checked);" <cfif isdefined("hasCheck") && hasCheck> checked="checked"</cfif>>
							</td>									
							<td align="left">#asset.name()#</td>	
							<td align="center">#asset.targetDate()#</td>															
						</tr>
						</form>
						</cfif>
						</cfloop>																																						
					</table>	
						
						
					</td>
					
				</tr>
				
				<tr>
					
					<td>
								
	
					<p class="meta"><img src="/public/images/icons/book_48.png" height="20px"> <b>Place <cfif val(reply.initiative.ledger().getPlaceTotalDallor())>(#dollarformat(reply.initiative.ledger().getPlaceTotalDallorBoon())# / #dollarformat(reply.initiative.ledger().getPlaceTotalDallor())#)</cfif></b></p>			
					<table>	
						<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
						<cfif listlast(getmetadata(asset).name, ".") is "Place">																								
						<form name="frm_addPlace#asset.id()#" id="frm_addPlace#asset.id()#" action="/ledger/cart/add" method="post">
						<tr>									
							<td><img src="/public/images/icons/circle_<cfif !asset.isBooked()>red<cfelseif reply.initiative.ledger().getPlaceTotalDallor() eq reply.initiative.ledger().getPlaceTotalDallorBoon()>green<cfelse>blue</cfif>.png" title="Booked (#asset.isBooked()#)" width="15px">&nbsp;&nbsp;#asset.name()#...</td>																
							<td>
								<cfif val(asset.cost())>
								<input type="text" name="amount" id="placeAmmount#asset.id()#" value="#IIF(asset.cost() GT 50, '50', '5')#" style="width:80px;">													
								</cfif>
							</td>
							<td>
								<cfif val(asset.cost())>											
									<input type="hidden" name="assetID" value="#asset.id()#">
									<input type="hidden" name="quantity" value="1">
									<input type="hidden" name="type" value="money">
									<a href='##' onclick='$("##frm_addPlace#asset.id()#").trigger("submit")' class="findoutmore">Add Cart</a>																						
								</cfif>
							</td>	
						</tr>	
						</form>
						<script>									
							$( '##frm_addPlace#asset.id()#' ).submit( function(){							
								var uri = $( this ).attr( 'action' );
								var object = $( this ).serializeForm();
								object.initiativeId = '#reply.initiative.id()#';
								object.DISPLAYCONTEXT = 'fpp';		
								$.callUri(uri,object);	
								
								<cfif request.browser EQ "suck">
									window.setTimeout(loadCart, 500, true);										
								</cfif>	
																						
								// loadCart();						
								return false;		
							});						
						</script>									
						</cfif>
						</cfloop>																											
					</table>								
						
					</td>
					
				</tr>
				
			</table>					
		</fieldset>
		</div>
		
		<div id="cartright">
		
			 
			<span id="displayCart">
				<cfinclude template="/view/initiative/cart.cfm" />							
			</span>	
			
				
		</div>
		
	</div>
	

	<script>
		$.ajaxSetup({ cache: false });
		
		$(document).bind('cartUpdated', function() {			
			loadCart();
		});	
		
		function randomNumber(){			
			return Math.floor(Math.random()*1111541);
		}
				
		function loadCart(){						
			var randomurinum = randomNumber();
			$('##displayCart').load('/ledger/cart?randnum='+randomurinum);	
		}
			
		function clearCart(){
			var doCartClear = $.post('/ledger/cart/clear', function() {
				loadCart();
			})					
		}
		
		function jsRemoveCartItem(uid){
			// alert("remove cart item");
			var doCartItemRemove = $.post('/ledger/cart/remove?uid=' + uid , function() {
				loadCart();
			})					
		}			


		function toggelPeople(assetid, checked){					
			// alert("people " + checked);
			if (checked == true){					
				var addPeople = $.post('/ledger/cart/add?assetID=' + assetid + '&quantity=0&type=people&initiativeId=#reply.initiative.id()#', function() {												
					loadCart();
					// window.setTimeout(loadCart, 1000, true);																													
				})	
			}
			else {
				var removePeople = $.post('/ledger/cart/remove?uid=' + assetid, function() {
					loadCart();
					// window.setTimeout(loadCart, 1000, true);
				})												
			}
												
		}				
										
	</script>	

	
</body>

</cfoutput>
