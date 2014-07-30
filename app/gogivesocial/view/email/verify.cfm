<plait:use layout="none" />

<cfoutput>	
<body>	

<div id="maincontent" class="bodywidth">

	
	<div id="aboutleft">	
		<fieldset>	
		<legend>We sent you an email.</legend>	
	    <h3 class="meta"><b>Account created... Active status is pending the following action:</b></h3>
		<p><img src="/public/images/icons/circle_green.png" width="15px"> Check your email box: <b>#reply.user.email()#</b></p>
	    <p><img src="/public/images/icons/circle_green.png" width="15px"> <b style="color:red">Please check your spam folder.</b></p>
	    <p><img src="/public/images/icons/circle_green.png" width="15px"> Click on the confirmation link in the email</p>
	    <p><img src="/public/images/icons/circle_green.png" width="15px"> <a href="/">Click here</a> if you do not receive the email</p>
		</fieldset>
	</div>
		
	<cfinclude template="/view/training/sidebar.cfm" />
	
</div>	

<script type="text/javascript">
	$(document).ready(function(){				
		$(document).bind('emailVerified', function(event, eventObject) {					
			var uri = '/account/profile';	
			var displayContext = 'page';		
			var object = {DISPLAYCONTEXT:displayContext};
			$.callMvc(uri,object);
		});			
	});			     						 
</script>		
			
</body>
</cfoutput>