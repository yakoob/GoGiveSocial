<cfoutput>

<script type="text/javascript" src="/public/javascript/fileuploader.js"></script>
<link href="/public/css/fileuploader.css" rel="stylesheet" type="text/css" />

<br>

<aside id="introduction" class="bodywidth"> 	
	<div id="initiativeleft"> 
		<fieldset>
			<legend>Initiative</legend>
		  	<h2 class="title" style="color:##4086C6;">#reply.initiative.name()#</h2>			
			#invoke.SocialPlugin().display(infoPath="/initiative/#reply.initiative.id()#", summary=reply.initiative.name())#					
		</fieldset>			
	</div>	
	<div id="introright">			
		<fieldset>		
			<legend>Initiative Ledger</legend>						
			<cfif isdefined("reply.hasLedgerDraft") && reply.hasLedgerDraft>
			<a href="/initiative/#reply.initiative.id()#/ledger/draft"><img src="/public/images/icons/app_48.png" width="20" border="0"> Manage Ledger</a><br>
			</cfif>						
			<cfset initiative = reply.initiative>			
			<cfset iDescribe.statsOnly = true>
			<cfset iDescribe.textLength = 0>
			<cfinclude template="/view/initiative/contribution_summary.cfm" >
			<br>	
			<a class="donate" title="Donate" href="/initiative/#reply.initiative.id()#/ledger">Donate</a>								
		</fieldset>		
	</div>
</aside>	

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


<div id="maincontent" class="bodywidth">

	
	<!---<div id="initiativeleft">		--->	
		<fieldset>							
		<legend>Summary</legend>	
		<p>
			<span style='color:red'><b>This Initiative is for Demonstration purposes only</b></span><br>	
			#reply.initiative.summary()#
		</p>
		<br>
		
		<div id="assetImages#reply.initiative.id()#"></div>				

		<cfif session.user.id() eq reply.initiative.user().id()>
			<br>
			<div class="donate" id="asset_initiative#reply.initiative.id()#_uploader"></div>
		</cfif>
		
		</fieldset>		
		
		<script>
			$(document).ready(function(){
				displayInitiativeImages();
			});
		</script>

		<!--- 
		<h2>Targets</h2>
		<span class="bullet">2,3,5,5,4</span>
		<p>GoDate: #dateformat(reply.initiative.date(), "full")#</p>
		--->
		
		<cfif len(reply.initiative.issue())>		
		<br>
		<fieldset>		
		<legend>What's the issue or challange?</legend>
		<p>#reply.initiative.issue()#</p>
		</fieldset>			
		</cfif>
		
		<cfif len(reply.initiative.solution())>
		<br>
		<fieldset>		
		<legend>How does this initiative solve the issue/challange?</legend>
		<p>#reply.initiative.solution()#</p>	
		</fieldset>		
		</cfif>
		
		<cfif len(reply.initiative.message())>		
		<br>
		<fieldset>		
		<legend>Initiative Message</legend>
		<p>#reply.initiative.message()#</p>		
		</fieldset>		
		</cfif>

		
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
				
		<div id="displayBlogNew_#reply.initiative.id()#"></div>			
		
		
		<br>
		<fieldset>
			<legend>Add this JavaScript Widget to your site</legend>	
			<div>			
				<div style="float:left;">
				<textarea><script src="#request.app.http#www.gogivesocial.com/public/javascript/widget.js"></script><span id="ggs_display_widget" ggs_type="initiative" ggs_id="#reply.initiative.id()#"></span></textarea>										
				</div>	
				<div style="float:right;">
					<script src="#request.app.http#www.gogivesocial.com/public/javascript/widget.js"></script><span id="ggs_display_widget" ggs_type="initiative" ggs_id="#reply.initiative.id()#"></span>
				</div>		
			</div>
		</fieldset>	
			
		<p><a class="donate" href="/initiative/#reply.initiative.id()#/ledger" title="Donate">Donate</a></p>	
	
	<!--- 		
	</div>
	
	
	<cfinclude template="/view/initiative/contributors.cfm" />			
	--->
</div>

</cfoutput>