<plait:use layout="layout" />
<cfoutput>		
<html>
	<head>		
	<meta name="robots" content="index, follow" />
	<meta name="description" content="#reply.seopage.description()#" />
	<meta name="keywords" content="#reply.seopage.keywords()#" />
	<link rel="canonical" href="http://#lcase(request.app.url)#/#reply.seopage.page()#" /> 
	<title> - #reply.seopage.title()#</title>		
	</head>	
	<body>	


	
	<aside id="introduction" class="bodywidth">
	  <div id="introleft">
	    <h2>#reply.seopage.title()#</h2>	   	   
	  </div>	  
	</aside>		

	<div id="maincontent" class="bodywidth">
		<div id="aboutleft">	
			<cfinclude template="/view/seo/body.cfm">
		</div>
		<cfinclude template="/view/training/sidebar.cfm" />	
	</div>	
	
	</body>
</html>
</cfoutput>