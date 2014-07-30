<plait:use layout="layout" />
<html>
	<cfoutput>
	<head>
	<title> - #reply.title# #reply.initiative.name()#</title>			
	
	#invoke.SocialPlugin().metadata(
		name=reply.initiative.name()
	,	description=invoke.String().removeHtml(reply.initiative.summary())
	,	image="#request.app.http##lcase(request.app.url)#/public/images/logo.png"
	,	url="#request.app.http##lcase(request.app.url)#/initiative/#reply.initiative.id()#"
	)#	
				
	<script>	
	$(document).ready(function(){	
		var uri = '/blog/search/initiative';
		var displayContext = 'displayBlogNew_#reply.initiative.id()#';					
		var object = {DISPLAYCONTEXT:displayContext,INITIATIVEID:#reply.initiative.id()#};
		$.callMvc(uri,object);			
		$('.bullet').sparkline('html', { type: 'bullet',  targetColor:'##228B22', performanceColor:'##099B00', rangeColors:['green','red', '##B0C4DE'], width:'110px', height:'15px'} );	
		$('##asset_initiative#reply.initiative.id()#_images').load('/initiative/#reply.initiative.id()#/images');			
	});	
	</script>
		
	<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>		
	<script type="text/javascript"> 
	$(document).ready(function() {		 
		$('.workload').workload();			
	});
	</script> 				
	</head>
	
	<body>	
		<cfinclude template="initiative.cfm" >
	</body>
	</cfoutput>
</html>


