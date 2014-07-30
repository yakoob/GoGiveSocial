<plait:use layout="layout" />
<head>
	<title> - New Account</title>
</head>	
<body>	
<br>

<div id="maincontent" class="bodywidth">
<cfoutput>
	
	<div id="aboutleft">						

	<fieldset>	
	<legend>Step 1: Who are you?</legend>	
		<p><i><b>"You're 90 seconds from having the best tools for managing <b>Go<span style="color:red">Give</span>Social</b> initiatives."</b></i></p>
		<div class="entry">
			<form action="/#reply.formAction#" method="get" id="webForm">			
				
				<div class="form_control">							
					<blockquote>							
					<input data-id="accountType" type="radio" name="po:account[type]" value="Organization" rel="/account/type/organization" checked="checked"  /> a non-profit organization?<br />
					<input data-id="accountType" type="radio" name="po:account[type]" value="Education" rel="/account/type/education" /> an education institution? <br />
					<input data-id="accountType" type="radio" name="po:account[type]" value="Company" rel="/account/type/company" /> a company?<br />
					<!---<input data-id="accountType" type="radio" name="po:account[type]" value="Individual" rel="/account/type/individual" /> a individual?--->			
					</blockquote>		
				</div>
				<br>
				<div id="form_accountType">
				<cfinclude template="/view/account/type_organization.cfm" />
				</div>
										
				<cfinclude template="/view/account/contact_info.cfm" />					
				
				<!--- 				
				<div class="form_control">
					<label>Url Path: "http://gogivesocial.com/{<b>MyName</b>}"</label>
					<input type="text" name="po:account[urlpath]" value="" placeholder="Allowed: [a-z][A-Z]" pattern="[a-zA-Z]*"/>						
				</div>
				--->
				
				<cfinclude template="/view/util/captcha.cfm" />					
				
				<div class="form_control">
					<label></label>
					<input type="submit" value="#reply.submitButton#" /> <!--- class="findoutmore" --->
				</div>
				
				<input type="hidden" name="displayContext" id="displayContext" value="content">
				<input type="hidden" name="eventname" id="eventname" value="accountCreated">
			</form>
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
			
</cfoutput>
</div>


</body>
</html>