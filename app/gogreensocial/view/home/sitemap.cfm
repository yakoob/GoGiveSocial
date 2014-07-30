<plait:use layout="layout" />
<head>		 			
	<title> - Sitemap</title>
</head>

<body>	
<cfoutput>
<div id="main">
	<div id="content">		
		<div class="post">				
			<h2 class="title">Privacy Policy</h2>				
			<div class="entry">						
			<cfif isArray(reply.sitemap) && ArrayLen(reply.sitemap) gt 1>
			
			<div style="float:left; width:250px; text-align:left">
				<cfloop index="i" from="1" to="#int(arraylen(reply.sitemap)/2)#">
					<b>#reply.sitemap[i].title()#</b> <a href="/#reply.sitemap[i].page()#">#reply.sitemap[i].title()#</a><br />				
				</cfloop>
			</div>
			
			<div style="float:right; width:250px; text-align:left;"  >
				<div style="float:left; width:250px; text-align:left">
					<cfloop index="i" from="#int(arraylen(reply.sitemap)/2)+1#" to="#arraylen(reply.sitemap)#">
						<b>#reply.sitemap[i].title()#</b> <a href="/#reply.sitemap[i].page()#">#reply.sitemap[i].title()#</a><br />				
					</cfloop>
				</div>
			</div>						
			</cfif>								 
			</div>
		</div>	
	</div>
</div>
<cfinclude template="/view/training/sidebar.cfm" />				
</cfoutput>
</body>
