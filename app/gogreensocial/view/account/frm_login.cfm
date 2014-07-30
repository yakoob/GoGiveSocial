					
<div class="entry">								
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
	<span style="float:right; margin-right:170px; padding-top:5px"><input type="submit" value="Login" /></span>
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
	<span style="float:right; margin-right:170px; padding-top:5px">
		Are you not a member? <input type="submit" value="Get Started!">
	</span>
	</div>		
	</form>	
	<script>
	$( '#registerForm' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'page';		
		$.callMvc(uri,object);						 
		return false;		
	});									 	
	</script>
				
	
</div>				
<p><br>	