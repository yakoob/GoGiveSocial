<plait:use layout="layout" />
<html>
	<cfoutput>
	<head>
		<title> - #reply.title#</title>	
	</head>
	<body>	
		<div id="content" style="width:650px">			
			<div class="post">							
				<fieldset>
				<legend>#reply.initiative.name()# Ledger...</legend>																
				<table>				
					<tr>
						<td>
						<p class="meta"><img src="/public/images/icons/app_48.png" height="20px"> <b>Material (#dollarformat(reply.initiative.ledger().getMaterialTotalDallorBoon())# / #dollarformat(reply.initiative.ledger().getMaterialTotalDallor())#)</b></p>			
						<table cellspacing="2" cellpadding="4">								
						
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
									<!--- <img width="20px" src="/public/images/icons/cart_add.png" onclick='addx(#asset.id()#, $("##donationQuantity_#asset.id()#").val(), $("##donationType_#asset.id()#").val() );'> --->
									<input type="hidden" name="assetID" value="#asset.id()#">
									<a href='##' onclick='$("##frm_addMaterial#asset.id()#").trigger("submit")'><img border="0" width="20px" src="/public/images/icons/cart_add.png"> Add Cart</a>
								
								</td>			
							</tr>														
						 
							<script>									
								$( '##frm_addMaterial#asset.id()#' ).submit( function(){							
									var uri = $( this ).attr( 'action' );
									var object = $( this ).serializeForm();
									object.DISPLAYCONTEXT = 'fpp';		
									object.initiativeId = '#reply.initiative.id()#';
									$.callUri(uri,object);																
									<cfif request.browser EQ "suck">
										window.setTimeout(loadCart, 1000, true);										
									</cfif>																																	
									return false;		
								});						
							</script>										
							</form>
								
							</cfif>
							
							
							</cfloop>		
																							
						</table>														
						<br>							
						
						<p class="meta"><img src="/public/images/icons/users_two_add_48.png" height="20px"> <b>People</b></p>			
						<table align="left" width="100%" cellspacing="2" cellpadding="4">				
							
							<tr>																											
							<th></th>
							<th>Volunteer</th>
							<th align="left">Job Description</th>
							<th>Target Date</th>
							
							</tr>
															
							<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
							<cfif listlast(getmetadata(asset).name, ".") is "People">													
								<form name="frm_addPeople#asset.id()#" id="frm_addPeople#asset.id()#" action="/ledger/cart/add" method="post">
								<cfloop array="#session.cart.items#" index="ii">
									<cfif ii.assetid eq asset.id()>
									<cfset hasCheck = true>
									</cfif>
								</cfloop>
								<tr>
									<td align="center"><img src="/public/images/icons/circle_blue.png" width="15px"> </td>									
									<td align="center">
										<!--- (#reply.initiative.ledger().getTotalVolunteerBoon()#/#reply.initiative.ledger().getTotalVolunteer()#)<br> --->
										<input name="togglePeople#asset.id()#" id="togglePeople#asset.id()#" onclick="toggelPeople(#asset.id()#,this.checked)"  type="checkbox" <cfif isdefined("hasCheck") && hasCheck> checked="checked"</cfif>>
									</td>																			
									<td align="left">#asset.name()#</td>	
									<td align="center">#asset.targetDate()#</td>															
								</tr>
								</form>
							</cfif>
							</cfloop>	
							<script>
							function toggelPeople(assetid, checked){									
								if (checked == true){					
									var addPeople = $.post('/ledger/cart/add?assetID=' + assetid + '&quantity=0&type=people', function() {									
									})	
								}
								else {
									var removePeople = $.post('/ledger/cart/remove?uid=' + assetid, function() {											
									})												
								}																		
							}											
							</script>																																	
						</table>

						<br>
						
						<p class="meta"><img src="/public/images/icons/book_48.png" height="20px"> <b>Place <cfif val(reply.initiative.ledger().getPlaceTotalDallor())>(#dollarformat(reply.initiative.ledger().getPlaceTotalDallorBoon())# / #dollarformat(reply.initiative.ledger().getPlaceTotalDallor())#)</cfif></b></p>			
						<table>	
							<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
							<cfif listlast(getmetadata(asset).name, ".") is "Place">																								
							<form name="frm_addPlace#asset.id()#" id="frm_addPlace#asset.id()#" action="/ledger/cart/add" method="post">
							<tr>									
								<td><img src="/public/images/icons/circle_<cfif !asset.isBooked()>red<cfelseif reply.initiative.ledger().getPlaceTotalDallor() eq reply.initiative.ledger().getPlaceTotalDallorBoon()>green<cfelse>blue</cfif>.png" title="Booked (#asset.isBooked()#)" width="15px">&nbsp;&nbsp;#asset.name()#...</td>																
								<td>
									<cfif val(asset.cost())>
									<input type="text" name="amount" id="placeAmmount#asset.id()#" value="#IIF(asset.cost() GT 50, '50', '5')#">													
									</cfif>
								</td>
								<td>
									<cfif val(asset.cost())>											
										<input type="hidden" name="assetID" value="#asset.id()#">
										<input type="hidden" name="quantity" value="1">
										<input type="hidden" name="type" value="money">
										<a href='##' onclick='$("##frm_addPlace#asset.id()#").trigger("submit")'><img border="0" width="20px" src="/public/images/icons/cart_add.png"> Add Cart</a>																						
									</cfif>
								</td>	
							</tr>	
							</form>
							<script>									
								$( '##frm_addPlace#asset.id()#' ).submit( function(){							
									var uri = $( this ).attr( 'action' );
									var object = $( this ).serializeForm();
									object.DISPLAYCONTEXT = 'fpp';		
									object.initiativeId = '#reply.initiative.id()#';
									$.callUri(uri,object);							
									loadCart();						
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
		</div>
		
		
		
		
		
		
		<div id="sidebar">
			
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
						})	
					}
					else {
						var removePeople = $.post('/ledger/cart/remove?uid=' + assetid, function() {
							loadCart();
						})												
					}
														
				}																			
										
			</script>				

	
			<div id="displayCart">
				<cfinclude template="/view/initiative/cart.cfm" />				
			</div>	
			
		</div>
		

			
		<div id="fpp"></div>
	</body>

	</cfoutput>
</html>


