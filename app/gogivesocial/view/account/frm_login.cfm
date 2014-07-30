<div class="entry">								
	<h2 style="color:red;text-align:center;">Creating a new Initiative requires an account...</h2><br>
	<form action="/account/login" method="post" id="loginForm">	
	<div class="form_control">
		<label for="login[email]">Email:</label>
		<input type="text" id="login[email]" name="login[email]" />			
	</div>	
	<div class="form_control">
		<label for="login[password]">Password:</label>
		<input type="password" id="login[password]" name="login[password]"/>			
	</div>					
	<div class="form_submit">							
		<span style="float:left; margin-right:200px; padding-top:5px">	
			<a title="Login" class="findoutmore" onclick="javascript:$('#loginForm').submit();">Login</a>
		</span>
	</div>		
	</form>	
	 
	<script>
	$( '#loginForm' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'page';		
		$.callUri(uri,object);						 
		return false;		
	});									 	
	</script>

	<form action="/account/new" method="post" id="registerForm">			
	<div class="form_submit">							
	<span style="float:left; margin-right:200px; padding-top:5px">
		<a title="Create a new account" class="findoutmore" onclick="javascript:$('#registerForm').submit();">Are you not a member? Get Started!</a>		
	</span>
	</div>		
	</form>	
	<!--- 
	<script>
	$( '#registerForm' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'page';		
		$.callMvc(uri,object);						 
		return true;		
	});									 	
	</script>
	--->
</div>				
<p><br>	