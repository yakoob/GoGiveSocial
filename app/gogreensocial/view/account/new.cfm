<plait:use layout="none" />
<html>
	<cfoutput>
	<head>
		<title>#reply.title#</title>		
	</head>
	
	<body>	
		<div id="content">		
			<fieldset>
			<legend>Step 1: Who are you?</legend>				
			<div class="post">				
			<div id="content_left">				
				<!--- <cfinclude template="/app/gogreen/view/account/frm_login.cfm" /> --->														
				<p class="meta"><b>You're 90 seconds from having the best tools for managing GoGreenSocial initiatives.</b></p>		
				<div class="entry">
					<form action="/#reply.formAction#" method="get" id="webForm">			
						
						<div class="form_control">							
							<b>Is this account for:</b><br><br>			
							<blockquote>							
							<input data-id="accountType" type="radio" name="po:account[type]" value="Individual" rel="/account/type/individual" checked="checked" /> a individual?<br />
							<input data-id="accountType" type="radio" name="po:account[type]" value="Company" rel="/account/type/company" /> a company?<br />
							<input data-id="accountType" type="radio" name="po:account[type]" value="Organization" rel="/account/type/organization" /> a non-profit organization?<br />
							<input data-id="accountType" type="radio" name="po:account[type]" value="Education" rel="/account/type/education" /> an education institution?							
							</blockquote>		
						</div>
					
						<br>
				
						<div id="form_accountType">
						<cfinclude template="/view/account/type_individual.cfm" />
						</div>
												
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
			</fieldset>
		</div>
		
		<cfinclude template="/view/training/sidebar.cfm" />	

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
