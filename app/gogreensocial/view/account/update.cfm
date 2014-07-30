<plait:use layout="none" />
<html>
	<cfoutput>
	<head>
		<title>#reply.title#</title>		
	</head>
	
	<body>	
		<div id="content">		
			<div class="post">				
			<div id="content_left">				
				<h2 class="title">Edit My Profile</h2>
				<div class="entry">
					<form action="/#reply.formAction#" method="get" id="webForm">			
																				
						<cfinclude template="/view/account/contact_info.cfm" />					
						
						<cfinclude template="/view/util/captcha.cfm" />					
						
						
						<div class="form_submit">
							<input type="submit" value="#reply.submitButton#" />
						</div>
						
						<input type="hidden" name="displayContext" id="displayContext" value="content">
						<input type="hidden" name="eventname" id="eventname" value="accountCreated">
					</form>
				</div>
			</div>
			</div>
		</div>
		
		<script type="text/javascript">
			$(document).ready(function(){
			
				$( '##webForm' ).submit( function(){
					var obj = $( this ).serializeForm();	
					var uri = $( this ).attr( 'action' );
					
					obj.DISPLAYCONTEXT = 'page';										
					$.callUri(uri,obj);
					return false;
				});			
															
				$('input:radio[data-id=accountType]').click( function(){				
					var accountType = $(this + ':checked').val();	
					var uri = $( this ).attr( 'rel' );
					var displayContext = 'form_accountType';					
					var object = {DISPLAYCONTEXT:displayContext, ACCOUNTTYPE:accountType};
					$.callUri(uri,object);					
				});
			
				$(document).bind('accountCreated', function(event, eventObject) {					
					var uri = '/email/verify';	
					var displayContext = 'site_ggs';		
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
