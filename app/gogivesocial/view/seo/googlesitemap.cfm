<plait:use layout="file_layout" />
<body>
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	
		<cfoutput>
			<cfloop index="i" from="1" to="#arraylen(reply.sitemap)#">
			<url>
				<loc>http://#lcase(request.app.url)#/#reply.sitemap[i].page()#</loc>
			</url>				
			</cfloop>
		</cfoutput>
</urlset>

</body> 
