<plait:use layout="layout" />
<html>
	<cfoutput>
	<head>
		<title>GoGiveSocial - Logout</title>		
	</head>
	
	<body>			
		
		<div id="maincontent" class="bodywidth">
		
			<div id="aboutleft">									
			<fieldset>	
			<legend>You have signed off</legend>	
			<cfinclude template="/view/account/frm_login.cfm" />
			</fieldset>										
			</div>
			
			<cfinclude template="/view/training/sidebar.cfm" />
		
		</div>

		<script>	
		$('li').each(function(index) {
			$(this).removeClass("current_page_item");			
		});		
		
		var tab = tab ? tab : 'home';				
		$('##tab_login').addClass("current_page_item");	
		</script>
				
	</body>
	</cfoutput>
</html>


