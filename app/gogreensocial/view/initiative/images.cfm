<plait:use layout="none" />
<html>

	<head>
		<script type="text/javascript" src="/public/javascript/jquery-latest.js"></script>
		<link media="screen" rel="stylesheet" href="/public/css/colorbox.css" />	
		<script type="text/javascript" src="/public/javascript/jquery.colorbox.js"></script>	
	</head>
	<body>
		
	<cfloop array="#reply.images#" index="i" >
	
	<cfif findnocase("thumb_", i)>
	
	<cfset fullimage = listlast(i,"\")>
	<cfset fullimage = replace(fullimage, "thumb_", "full_", "all")>
	<cfset fullimage = URLEncodedFormat(fullimage)>
	<cfoutput>			
	<a href="##" onclick='$.colorbox({innerWidth:"550px",innerHeight:"550px", href:"/initiative/image?image=#fullimage#&id=#reply.id#"})'>	
	<cfimage
	action="WRITETOBROWSER"
	source="#i#"
	format="jpg"
	/>
	</a>
	</cfoutput>
	</cfif>
	</cfloop>
	
	
		
	</body>

</html>
