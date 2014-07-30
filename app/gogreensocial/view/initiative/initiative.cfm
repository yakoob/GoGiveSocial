<cfoutput>
<script type="text/javascript" src="/public/javascript/fileuploader.js"></script>	
<link href="/public/css/fileuploader.css" rel="stylesheet" type="text/css" />

<div id="content">			

	<script>
		<cfif session.user.id() eq reply.initiative.user().id()>
			function randomNumber(){			
				return Math.floor(Math.random()*1111541);
			}			
			function createUploader(){            
				var uploader = new qq.FileUploader({
					element: document.getElementById('asset_initiative#reply.initiative.id()#_uploader')			
					,action: '/public/remote/Upload.cfc'		
					,params: {method: 'Upload', location: 'initiative/#reply.initiative.id()#/'}		
					,allowedExtensions: ['jpg','jpeg','png','gif'] 
					,onComplete: function(id, fileName, responseJSON){							
						displayInitiativeImages();			
					}
				});      			
			} 
			window.onload = createUploader;     
		</cfif>
		function displayInitiativeImages(){
			var uri = '/initiative/#reply.initiative.id()#/images';		
			var displayContext = 'assetImages#reply.initiative.id()#';					
			var object = {DISPLAYCONTEXT:displayContext,INITIATIVEID:#reply.initiative.id()#};
			$.callMvc(uri,object);		
		}				
	</script>    

	<div class="post">							
			
		<fieldset>
		<legend>Initiative</legend>				
		<h2 class="title">#reply.initiative.name()#</h2>				
		#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary=reply.initiative.name())#										
		</fieldset>
		
		<br>		
		
		<fieldset>
		<legend>Initiative Summary</legend>													
	 
	 	<cfif !isnull(reply.initiative.account())>
		<cfif reply.initiative.account().status() NEQ "active">
		<p><span style='color:red'>This Initiative is for Demonstration purposes only</span></p>
		</cfif>
		</cfif>
		
		<p>#reply.initiative.summary()#</p>
		
		<cfif session.user.id() eq reply.initiative.user().id()>
			<div id="asset_initiative#reply.initiative.id()#_uploader">		
			<noscript>			
				<p>Please enable JavaScript to use file uploader.</p>						
			</noscript>         
			</div>
		</cfif>				
		<div id="assetImages#reply.initiative.id()#"></div>		
		<br>
		</fieldset>
		
		<br>
		
		<script>
			$(document).ready(function(){
				displayInitiativeImages();
			});
		</script>				
		
		
		<cfif len(reply.initiative.issue())>
		<fieldset>
		<legend>What's the issue or challange?</legend>										
		<p>#reply.initiative.issue()#</p>
		</fieldset>
		<br>
		</cfif>
		
		<cfif len(reply.initiative.solution())>
		<fieldset>
		<legend>How does this initiative solve the issue?</legend>				
		<p>#reply.initiative.solution()#</p>
		</fieldset>
		<br>
		</cfif>
		
		<cfif len(reply.initiative.message())>
		<fieldset>
		<legend>Initiative Message</legend>						
		<p>#reply.initiative.message()#</p>
		</fieldset>		
		<br>
		</cfif>
		
		<fieldset>
		<legend>Your Donation makes a difference!</legend>	
		<p><a href="/initiative/#reply.initiative.id()#/ledger" title="Donate"><b>Please help us achieive our goals by your contribution</b></a></p>								
		</fieldset>
		
		<br>
		
		<fieldset>
		<legend>Partners</legend>				
		<cfif not arraylen(reply.initiative.ledger().getVolunteers())>
			Currently no partners
		<cfelse>		
			<cfloop index="i" from="1" to="#arraylen(reply.initiative.ledger().getVolunteers())#">							
			<cfset bannerFile = request.app.root & "/public/images/profile_unknown.png">				
			<cfset img = imageNew(bannerFile)>				
			<cfset imageSetAntialiasing(img,"on")>
			<cfset imageSetDrawingColor(img,"black")>				
			<cfset line1 = reply.initiative.ledger().getVolunteers()[i].firstname() & " " & reply.initiative.ledger().getVolunteers()[i].lastname()>				
			<!--- draw the first line of text --->
			<cfset font = "Arial">
			<cfset style = "">
			<cfset size = 16>
			<cfset pos = invoke.imageUtils().getCenteredTextPosition(img, line1, font, style, size)>
			<cfset tProps =  { style=style, size=size, font=font }>
			<cfset imageSetDrawingColor(img,"black")>
			<cfset imageDrawText(img, line1, pos.x, pos.y, tProps)>
			<cfimage action="writeToBrowser" source="#img#" width="100px">									
			 &nbsp;</cfloop>	
		</cfif>										
		</fieldset>
				
		<br>
		<!--- 
		<fieldset>
		<legend>Blog out this Initiative</legend>	
		<div id="displayBlogNew_#reply.initiative.id()#"></div>							
		</fieldset>												
		
		<br>
		--->
		<fieldset>
			<legend>Add this JavaScript Widget to your site</legend>	
			<div>			
				<div style="float:left;">
				<textarea style="width: 249px; font-size:14px;"><script src="#request.app.http#www.gogreensocial.com/public/javascript/widget.js"></script><span id="ggs_display_widget" ggs_type="initiative" ggs_id="#reply.initiative.id()#"></span></textarea>										
				</div>	
				<div style="float:right;">
					<script src="#request.app.http#www.gogreensocial.com/public/javascript/widget.js"></script><span id="ggs_display_widget" ggs_type="initiative" ggs_id="#reply.initiative.id()#"></span>
				</div>		
			</div>
		</fieldset>		
	
	
	</div>
	
	<!--- <cfdump var="#reply#"> --->
	
</div>

<div id="sidebar" >	
	
	<fieldset>
	<legend>Initiative Ledger</legend>	
	<cfif isdefined("reply.hasLedgerDraft") && reply.hasLedgerDraft>
	<a href="/initiative/#reply.initiative.id()#/ledger/draft"><img src="/public/images/icons/app_48.png" width="20" border="0"> Manage Ledger</a><br>
	</cfif>						
	<cfset initiative = reply.initiative>
	<cfset iDescribe.statsOnly = true>
	<cfinclude template="/view/initiative/contribution_summary.cfm" >
	<br>	
	<a class="donate" title="Donate" href="/initiative/#reply.initiative.id()#/ledger"><b>Make a Donatation</b></a>
	</fieldset>	
	<br>
	
	<cfinclude template="/view/training/owner.cfm" />
	<br>
	
	<!--- 
	<fieldset>
	<!--- do not display more than 14 letters here --->
	<legend>Costa Rica</legend>						
	<cfmap name="initiative_map_#reply.initiative.id()#" 
		centeraddress="Costa Rica" 
		doubleclickzoom="true" 
		scrollwheelzoom="true" 
		showscale="false" 
		hideborder="true"
		
		height="150"
		width="260" 
		typecontrol="none"  
		zoomlevel="0" 					
		   /> 
	</fieldset>
	<br>
	--->
				
	<!--- <cfinclude template="/view/initiative/related.cfm" /> --->
</div>

</script> 	

</cfoutput>



