<cfoutput>
<head>
<title> - #reply.account.name()#</title>
#invoke.SocialPlugin().metadata(name=reply.account.name(),description=reply.account.mission(),image="#request.app.http##lcase(request.app.url)##reply.account.getProfileImage()#",url="#request.app.http##lcase(request.app.url)#/#lcase(reply.account.urlPath())#")#
<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>
<script type="text/javascript" src="/public/javascript/fileuploader.js"></script>	
<link href="/public/css/fileuploader.css" rel="stylesheet" type="text/css" />
</head>

<body>	

<br>


<aside id="introduction" class="bodywidth" style="padding:0 20px 5px 20px;">

	<div style="float:left; width:15%; padding:0px;" >	
					
		<cfif !isnull(reply.account.address()) and arraylen( reply.account.address() )>									
			<fieldset style="width:155px;">
				<legend>Organization Info</legend>
				<cfif isdefined("reply.security.isOwner") AND reply.security.isOwner EQ true><span sytle="blockquote"><a href="">[upload logo]</a></cfif>					
				
				<cftry>
					
					<div style="text-align:center;">
					<cfimage
					action="WRITETOBROWSER"
					source="#reply.logPath#"
					format="png"											 				
					/>
					</div>				
					<cfcatch type="any">
						<img src="#reply.account.getProfileImage()#" width="150px">
					</cfcatch>
					
				</cftry>
					
				<br>											
				<b>#reply.account.name()#</b>
				<cfif len(trim(reply.account.website()))><a href="#reply.account.website()#">#replace(replace(reply.account.website(), "http://", ""), "www.", "")#</a><br></cfif>					
				#reply.account.address()[1].city()#, #reply.account.address()[1].state()#<br>					
				<cfif !arraylen(reply.account.initiatives())>
				<a href="http://#request.app.url#/account/#reply.account.id()#/donate" class="donate">Donate</a>
				</cfif>	
			</fieldset>
		</cfif>			

		<br>
		<fieldset style="width:155px;">
			<legend>Partners</legend>			

			<cfif isnull(reply.partners) || !arraylen(reply.partners)>
				Currently no partners
			<cfelse>	
								
				<cfloop array="#reply.partners#" index="i">							
				<cfif !isnull(i.firstname()) and len(i.firstname()) >
					<cfset bannerFile = request.app.root & "/public/images/partner_unknown.png">				
					<cfset img = imageNew(bannerFile)>				
					<cfset imageSetAntialiasing(img,"on")>
					<cfset imageSetDrawingColor(img,"black")>				
					<cfset line1 = i.firstname()>				
					<!--- draw the first line of text --->
					<cfset font = "Arial">
					<cfset style = "">
					<cfset size = 10>
					<cfset pos = invoke.imageUtils().getCenteredTextPosition(img, line1, font, style, size)>
					<cfset tProps =  { style=style, size=size, font=font }>
					<cfset imageSetDrawingColor(img,"black")>
					<cfset imageDrawText(img, line1, pos.x, pos.y, tProps)>
					<cfimage action="writeToBrowser" source="#img#" width="50px">		
				</cfif>							
				&nbsp;				 
				</cfloop>						
			</cfif>	
			
		</fieldset>		
					
				
	</div>
	<div style="float:right; width:75%;">				
		<!--- 
		<fieldset>
			<legend>Our Mission</legend>						
			<cfif isdefined("reply.security.isOwner") AND reply.security.isOwner EQ true><span sytle="blockquote"><a href="">[edit]</a> Click edit to add your Mission Statement...</cfif>#reply.account.mission()#
			<a href="<cfif cgi.http_host contains 'local.'>http://#request.app.url#<cfelse>https://#request.app.url#</cfif>/account/#reply.account.id()#/donate" class="donate">Donate</a>				
		</fieldset>
		<br>--->
		<fieldset>
			<legend>Please help us spread the word!</legend>	
			<h2 class="title"  style="color:##4086C6;">#reply.account.name()#</h2>	  		
			#invoke.SocialPlugin().display(infoPath="/#reply.account.urlPath()#", summary=left(reply.account.description(),140))#													
		</fieldset>
		<br>
		<cfif isdefined("reply.security.isOwner") AND reply.security.isOwner EQ true>		
			<script>	
			$(document).ready(function() {	   	
				$('##frm_search_initiatives').click(function(){
					$('##frm_search_initiatives').val("");	
					// $('##frm_search_initiatives').trigger('keyup');	
				});	
				
				$('##frm_search_initiatives').keyup( function(){		
					var uri = $( this ).attr( 'rel' );		
					var displayContext = 'initiative_partial_list';					
					var object = {DISPLAYCONTEXT:'initiatives_find',SEARCHSTRING:this.value};
					$.callMvc(uri,object);								 
				});
				
				$('##initiativeNew-href').click( function(){		
					var uri = $( this ).attr( 'rel' );
					var displayContext = 'initiative_new_form';								
					var object = {DISPLAYCONTEXT:displayContext};		
					$.callMvc(uri,object);				
				});			
			});
			</script>
		</cfif>
		
		<fieldset>			
		<legend>#reply.account.name()# Initiatives</legend>		
		
		<fieldset>
		<cfif len(trim(reply.account.mission()))><b>Our Mission: <i>"#reply.account.mission()#"</i></b><br><br></cfif>			
		
		<cfif arraylen(reply.account.initiatives())>You can make a general donation or you can customize your contribution in one of our Initiatives listed below.<br><br></cfif>
		
		<a href="http://#request.app.url#/account/#reply.account.id()#/donate"><img src="/public/images/icons/credit_cards.png"  width="20" border="0"> <b>Donate Today!</b></a>
		</fieldset>
		<br>
		<cfif arraylen(reply.account.initiatives())>		
			<cfloop array="#reply.account.initiatives()#" index="initiative">		 			
			<fieldset>
			<div id="initiatives_find">		
			<cfinclude template="/view/initiative/contribution_summary.cfm" >
			</div>		
			<br><br>				
			<a href="/initiative/#initiative.id()#"><img src="/public/images/icons/ok.png"  width="20" border="0"> <b>Donate Today!</b></a>
			<br>				
			</fieldset>
			<br>
			</cfloop>			
			<script type="text/javascript"> 
			$(document).ready(function() {		 
				$('.workload').workload();			
			});
			</script>						
		<cfelse>
			no initiatives match your criteria...
		</cfif>					
		</fieldset>																
	</div>					
			
	<div style="clear:both;">	
	<br>
	<fieldset>
		<legend>Add this JavaScript Widget to your site</legend>	
		<div>			
			<div style="float:left;">
			<textarea><script src="#request.app.http##request.app.url#/public/javascript/widget.js"></script><div id="ggs_display_widget" ggs_type="account" ggs_id="#lcase(reply.account.urlPath())#"></div></textarea>
			</div>	
			<div style="float:right;">
				<script src="#request.app.http##request.app.url#/public/javascript/widget.js"></script>
				<div id="ggs_display_widget" ggs_type="account" ggs_id="#lcase(reply.account.urlPath())#"></div>						
			</div>		
		</div>
	</fieldset>			
	</div>
</aside>	

</body>
</cfoutput>