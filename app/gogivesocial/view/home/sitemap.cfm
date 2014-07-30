<plait:use layout="layout" />
<head>		 			
	<title> - Sitemap</title>
</head>
<body>
<cfoutput>


	<div id="maincontent" class="bodywidth">
		
		<div id="aboutleft">

		<fieldset>	
		<legend>Sitemap</legend>		
		
		<cfif isArray(reply.sitemap) && ArrayLen(reply.sitemap) gt 1>
			
			<div style="float:left; width:250px; text-align:left">
				<cfloop index="i" from="1" to="#int(arraylen(reply.sitemap)/2)#">
					<b>#reply.sitemap[i].title()#</b> <a href="/#reply.sitemap[i].page()#">#reply.sitemap[i].title()#</a><br /><br>		
				</cfloop>
			</div>
			
			<div style="float:right; width:250px; text-align:left;"  >
				<div style="float:left; width:250px; text-align:left">
					<cfloop index="i" from="#int(arraylen(reply.sitemap)/2)+1#" to="#arraylen(reply.sitemap)#">
						<b>#reply.sitemap[i].title()#</b> <a href="/#reply.sitemap[i].page()#">#reply.sitemap[i].title()#</a><br /><br>			
					</cfloop>
				</div>
			</div>
			
		</legend>
			
		</cfif>
		</div>
	
		<cfinclude template="/view/training/sidebar.cfm" />
		
	</div>	
	

</cfoutput>

</body>
