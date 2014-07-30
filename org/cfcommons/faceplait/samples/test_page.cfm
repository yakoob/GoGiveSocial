<plait:use layout="sample_layout_3" />
<html>

	<head>
	
		<title>This is a cool title</title>
		
		<style type="text/css">
			LI {
				font-family: verdana;			
			}
		</style>
		
	</head>

	<body>
		
		<ul>
			<li><cfoutput>#testvariable#</cfoutput></li>
			<li><cfoutput>#form.bleh#</cfoutput></li>
		</ul>

	</body>
	
</html>