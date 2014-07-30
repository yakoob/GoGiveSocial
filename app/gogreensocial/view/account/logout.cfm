<plait:use layout="layout" />
<html>
	<cfoutput>
	<head>
		<title>GoGreenSocial - Logout</title>		
	</head>
	
	<body>	
		<div id="content">		
			<div class="post">				
			<div id="content_left">					
			
		
				<fieldset>
				<legend>You have logged out</legend>			
				<cfinclude template="/view/account/frm_login.cfm" />				
				</fieldset>
			</div>
			</div>
		
			
		</div>
		
		<cfinclude template="/view/training/sidebar.cfm" />	
		
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


