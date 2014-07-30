<plait:use layout="layout" />
<cfoutput>		
<html>
	<head>			
	<link rel="canonical" href="http://#lcase(request.app.url)#/404" /> 
	<title> - Error</title>		
	</head>	
	<body>	

	<aside id="introduction" class="bodywidth">
	  <div id="introleft">
	    <h2>An Error Has Occurred?</h2>	   	   
	  </div>	  
	</aside>		

	<div id="maincontent" class="bodywidth">
		<div id="aboutleft">				
			This issue has been logged and will be addressed by our technical team.
		</div>
		<cfinclude template="/view/training/sidebar.cfm" />	
	</div>	
	
	</body>
</html>
</cfoutput>