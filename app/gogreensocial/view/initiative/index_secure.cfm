<plait:use layout="member" />
<html>
	<cfoutput>
	<head>
		<title> - #reply.title# #reply.initiative.name()#</title>	
	</head>	
	<body>	
		<cfinclude template="initiative.cfm" >
		<script>
		$('li').each(function(index) {
			$(this).removeClass("current_page_item");			
		});		
		var tab = tab ? tab : 'findinitiatives';				
		$('##tab_' + tab).addClass("current_page_item");			
		</script>
	</body>
	</cfoutput>
</html>


