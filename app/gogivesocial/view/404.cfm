<plait:use layout="layout" />
<cfoutput>		
<html>
<head>			
<link rel="canonical" href="http://#lcase(request.app.url)#/404" /> 
<title> - Page not found!</title>		
</head>	

<body>	
<br>
<aside id="introduction" class="bodywidth">
	<div id="introleft">
		<fieldset>
			<legend>Page not found</legend>	
			<p><b>Sorry, the page you requested does not exist.</b></p>			
		</fieldset>
	</div>
	<div id="nonprofitright">				
		<cfinclude template="/view/training/sidebar.cfm" />	
	</div>
</aside>	

<div id="maincontent" class="bodywidth"></div>
</body>

</cfoutput>