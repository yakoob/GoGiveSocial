<plait:use layout="member" />
<html>
	<cfoutput>
	<head>
		<title> - #reply.title# #reply.initiative.name()#</title>	
		<script>	
		$(document).ready(function(){
			// get blog			
			var uri = '/blog/search/initiative';
			var displayContext = 'displayBlogNew_#reply.initiative.id()#';					
			var object = {DISPLAYCONTEXT:displayContext,INITIATIVEID:#reply.initiative.id()#};
			$.callMvc(uri,object);		
					
			$('.bullet').sparkline('html', { type: 'bullet',  targetColor:'##228B22', performanceColor:'##099B00', rangeColors:['green','red', '##B0C4DE'], width:'60px', height:'15px'} );
					
		});
		</script>
				
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


