<plait:use layout="no_layout" />
<html>	
	<cfoutput>	
	<head>
		<title>Verify Email</title>		
	</head>
	
	<body>
	
	<div id="main">
		<div id="content">
			
			<div class="post">				
				<h2 class="title"><img src="/public/images/icons/mail_spam_48.png" width="35px"> <cfoutput>We sent you an email.</cfoutput></h2>						
				<div class="entry">	
					<ul>					
				    <li><h3 class="meta"><b>Account created... Active status is pending the following action:</b></h3></li>
					<li><img src="/public/images/icons/circle_green.png" width="15px"> Check your email box: <b>#reply.user.email()#</b></li>
				    <li><img src="/public/images/icons/circle_green.png" width="15px"> <b style="color:red">Please check your spam folder.</b></li>
				    <li><img src="/public/images/icons/circle_green.png" width="15px"> Click on the confirmation link in the email</li>
				    <li><img src="/public/images/icons/circle_green.png" width="15px"> <a href="##">Click here</a> if you do not receive the email</li>
					</ul>												
				</div>									
			</div>			
		</div>		
		<cfinclude template="/view/training/sidebar.cfm" />							
	</div>
	
	<script type="text/javascript">
		$(document).ready(function(){				
			$(document).bind('emailVerified', function(event, eventObject) {					
				var uri = '/profile';	
				var displayContext = 'page';		
				var object = {DISPLAYCONTEXT:displayContext};
				$.callMvc(uri,object);
			});			
		});			     						 
	</script>		
				
	</body>
	</cfoutput>
</html>
<!--- 
DISPLAYMETHOD	html
account[city]	Rancho Palos Verdes
account[name]	balls school
account[state]	CA
account[streetAddress2]	
account[streetAddress]	512 some place
account[type]	Education
account[zip]	90275
displayContext	content
user[email]	yakoob@gogreensocial.com
user[firstname]	yakoob
user[lastname]	ahmad
user[password]	games01
--->
