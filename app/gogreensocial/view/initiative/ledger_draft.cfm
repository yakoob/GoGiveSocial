<plait:use layout="member" />
<html>
	<cfoutput>
	<head>
		<title> - #reply.title#</title>	
	</head>
	<body>	
	<div id="fpp"></div>	
	<div id="content" style="width:100%">			
		<div class="post">				
			<h2 class="title">"#reply.initiative.name()#" Ledger...</h2>								
			<div class="entry">									
				<table>											
					
					<tr>
						<td>
						<p class="meta"><img src="/public/images/icons/app_48.png" height="20px"> <b>Material</b> <a href="##" onclick="addMaterialItem()">Add Another <img src="/public/images/icons/add_16.png" border="0"></a></p>			
						<!--- (#dollarformat(reply.initiative.ledger().getMaterialTotalDallorBoon())# / #dollarformat(reply.initiative.ledger().getMaterialTotalDallor())#) --->
						<table cellspacing="2" cellpadding="2" id="materialtable">								
						<form id="frm_add" action="/blog/save" method="post" >
							<tr>																					
							<th>Item Cost</th>
							<th>Qty.</th>
							<th>Item Description</th>
							<th>Target Date</th>
							</tr>
							<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
							<cfif listlast(getmetadata(asset).name, ".") is "Material">								
							<tr>
								<td colspan="5"><div id="displayStatus_#asset.id()#"></div></td>
							</tr>
							<tr id="tr#asset.id()#">
								<td><input type="text" id="materialCost_#asset.id()#" value="#dollarformat(asset.getCost())#" style="width:125px;"></td>
								<td><input type="text" id="materialQuantity_#asset.id()#" value="#asset.getQuantity()#" style="width:125px;"></td>									
								<td align="center"><input type="text" id="materialAssetName_#asset.id()#" value="#asset.name()#" style="width:300px;"></td>
								<td><input type="text" id="materialDate_#asset.id()#"  value="#asset.targetDate()#" style="width:125px;" />	</td>
								<td>
									<a href="##"><img border="0" width="20px" src="/public/images/icons/floppy_disk_48.png" onclick=fncAssetSave(#asset.id()#,$("##materialQuantity_#asset.id()#").val(),$("##materialCost_#asset.id()#").val(),$("##materialAssetName_#asset.id()#").val(),$("##materialDate_#asset.id()#").val())></a>
									<a href="##"><img border="0" width="20px" src="/public/images/icons/cancel_16.png" onclick=fncAssetDelete(#asset.id()#)></a>
								</td>			
							</tr>
							</cfif>
							
							<script>		
							$(function() {
								$( "##materialDate_#asset.id()#" ).datepicker();
							});										
							</script>
							</cfloop>		
						</form>																
						</table>
																				
						<script>
							function addMaterialItem(){									
								$.post('/asset/new/material/#reply.initiative.ledger().id()#.json', function(data) {
									var tmpId = data;																		                    																																																																																																																																													
									$('##materialtable tr:last').after('<tr id="tr'+tmpId+'"><td><input type=text id=materialCost_' + tmpId + ' value="0" style="width:125px;"></td><td><input type=text id=materialQuantity_' + tmpId + ' value="0" style="width:125px;"></td><td align=center><input type=text id=materialAssetName_' + tmpId + ' value="" style="width:300px;"></td><td><input type=text id=materialDate_' + tmpId + ' style="width:125px"/></td><td><a href="##"><img onclick=fncAssetSave('+tmpId+',$("##materialQuantity_' + tmpId + '").val(),$("##materialCost_' + tmpId + '").val(),$("##materialAssetName_' + tmpId + '").val(),$("##materialDate_' + tmpId + '").val()) width=20px src=/public/images/icons/floppy_disk_48.png></a><a href="##"><img onclick=fncAssetDelete('+tmpId+')  width=20px src=/public/images/icons/cancel_16.png></a></td></tr>');										
									$( "##materialDate_" + tmpId ).datepicker();		
								});														
							}																																	
						</script>
						
						<br>				
						
						<p class="meta"><img src="/public/images/icons/users_two_add_48.png" height="20px"> <b>People</b> <a href="##" onclick="addPersonJob()">Add Another <img src="/public/images/icons/add_16.png" border="0"></a></p>			
						<table align="centers" id="persontable">			
							<tr>																											
							<th>People Needed</th>
							<th>Job Description</th>
							<th>Target Date</th>
							<th></th>
							</tr>
							<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
							<cfif listlast(getmetadata(asset).name, ".") is "People">																					
							<tr id="tr#asset.id()#">														
								<td align="center"><input type="text" id="personQuantity_#asset.id()#" value="#asset.getQuantity()#" style="width:125px;"></td>									
								<td align="center"><input type="text" id="personAssetName_#asset.id()#" value="#asset.name()#" style="width:300px;"></td>
								<td><input type="text" id="personDate_#asset.id()#"  value="#asset.targetDate()#" style="width:125px;" />	</td>
								<td>
									<img width="20px" src="/public/images/icons/floppy_disk_48.png" onclick=fncAssetSave(#asset.id()#,$("##personQuantity_#asset.id()#").val(),0,$("##personAssetName_#asset.id()#").val(),$("##personDate_#asset.id()#").val())>
									<img width="20px" src="/public/images/icons/cancel_16.png" onclick=fncAssetDelete(#asset.id()#)>																											
								</td>																								
							</tr>

							<script>		
							$(function() {
								$( "##personDate_#asset.id()#" ).datepicker();
							});										
							</script>

							</cfif>
							
							</cfloop>																																		
						</table>
						<script>
							
							function addPersonJob(){									
								$.post('/asset/new/person/#reply.initiative.ledger().id()#.json', function(data) {																																                    																																																																																																																																										
									$('##persontable tr:last').after('<tr id="tr'+data+'"><td><input type=text id=personQuantity_' + data + ' value="0" style="width:30px;"></td><td><input type=text id=personAssetName_' + data + ' value="" style="width:200px;"></td><td><input type=text id=personDate_' + data + ' style="width:100px"/></td><td><a href="##"><img onclick=fncAssetSave('+data+',$("##personQuantity_' + data + '").val(),$("##personCost_' + data + '").val(),$("##personAssetName_' + data + '").val(),$("##personDate_' + data + '").val()) width=20px src=/public/images/icons/floppy_disk_48.png></a><a href="##"><img onclick=fncAssetDelete('+data+')  width=20px src=/public/images/icons/cancel_16.png></a></td></tr>');										
									$( "##personDate_" + data ).datepicker();		
								});														
							}								
							
																																							
						</script>
						<br>
						
						<p class="meta"><img src="/public/images/icons/book_48.png" height="20px"> <b>Place</b> <a href="##" onclick="addPlace()">Add Another <img src="/public/images/icons/add_16.png" border="0"></a></p>							
						<table id="placetable">
							<tr>																											
							<th align="left">Place Description</th>
							<th>Place Cost</th>
							<th>Target Date</th>
							<th></th>
							</tr>								
							<cfloop array="#reply.initiative.ledger().assets()#" index="asset">
							<cfif listlast(getmetadata(asset).name, ".") is "Place">																								
							<tr id="tr#asset.id()#">																																	
								<td><input type="text" id="placeAssetName_#asset.id()#" value="#asset.name()#" style="width:300px;"></td>
								<td><input type="text" id="placeCost_#asset.id()#" value="#dollarformat(asset.getCost())#" style="width:125px;"></td>																												
								<td><input type="text" id="placeDate_#asset.id()#"  value="#asset.targetDate()#" style="width:125px;" /></td>									
								<td>
									<img width="20px" src="/public/images/icons/floppy_disk_48.png" onclick=fncAssetSave(#asset.id()#,1,$("##placeCost_#asset.id()#").val(),$("##placeAssetName_#asset.id()#").val(),$("##placeDate_#asset.id()#").val())>
									<img width="20px" src="/public/images/icons/cancel_16.png" onclick=fncAssetDelete(#asset.id()#)>																											
								</td>																										
							</tr>	
							<script>		
							$(function() {
								$("##placeDate_#asset.id()#").datepicker();
							});										
							</script>								
							</cfif>
							</cfloop>	
							<script>
							function addPlace(){									
								$.post('/asset/new/place/#reply.initiative.ledger().id()#.json', function(data) {
									var tmpId = data;																		                    																																																																																																																																													
									$('##placetable tr:last').after('<tr id="tr'+tmpId+'"><td><input type=text id=placeAssetName_' + tmpId + ' value="" style="width:300px;"></td><td><input type=text id=placeCost_' + tmpId + ' value="0" style="width:125px;"></td><td><input type=text id=placeDate_' + tmpId + ' style="width:125px"/></td><td><a href="##"><img border=0 onclick=fncAssetSave('+tmpId+',0,$("##placeCost_' + tmpId + '").val(),$("##placeAssetName_' + tmpId + '").val(),$("##placeDate_' + tmpId + '").val()) width=20px src=/public/images/icons/floppy_disk_48.png></a><a href="##"><img border=0 onclick=fncAssetDelete('+tmpId+')  width=20px src=/public/images/icons/cancel_16.png></a></td></tr>');										
									$( "##placeDate_" + tmpId ).datepicker();		
								});														
							}																																	
						</script>
						</table>							
						</td>							
					</tr>						
				</table>
			</div>
			<br>							
		</div>
		
	</div>
	
	<script>															
		function fncAssetSave(assetid, quantity, cost, name, date){
			var jqxhr = $.post('/asset/save/' + assetid + '.json?quantity=' + quantity  + '&cost=' + cost + '&name=' + name + '&date=' + date, function() {											
			$.jGrowl([name + ' -  saved'], { life: 1500 });	
			})															
		}			
		function fncAssetDelete(assetid){
			var jqxhr = $.post('/asset/delete/' + assetid + '.json', function() {				      						
				var trid = 'tr' + assetid;
				$(document.getElementById(trid)).remove();
			})										
		}														
	</script>	
	
	
	</body>

	</cfoutput>
</html>


