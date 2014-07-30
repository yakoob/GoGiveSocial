<plait:use layout="none" />
<body>

<cfoutput>
<div class="form_control">		
	
<fieldset>
	<legend>New Initiatives</legend>
			
	<form id="frm_initiativeNew" action="/initiative/save" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">		
	<div class="form_control">
		<label><span style="color:red">*</span> Target Date:</label>
		<input type="text" id="initiativeTargetDate" name="po:initiative[date]" />			
	</div>	
	<div class="form_control">
		<label><span style="color:red">*</span> Initiative Name:</label>
		<input type="text" name="po:initiative[name]" />			
	</div>
	<div class="form_control">
		<label><span style="color:red">*</span> Summary:</label>
		<textarea name="po:initiative[summary]"></textarea>					
	</div>				
	<div class="form_control">
		<label>(optional) What's the issue or challange?</label>
		<textarea name="po:initiative[issue]"></textarea>	
	</div>		
	<div class="form_control">
		<label>(optional) How does this initiative solve the issue/challange?</label>
		<textarea name="po:initiative[solution]"></textarea>	
	</div>		
	<div class="form_control">
		<label>(optional) Initiative Message:</label>
		<textarea name="po:initiative[message]"></textarea>			
	</div>	
	<div class="form_contorl">
		<label></label>
		<input type="submit" name="submit" id="submit" value="Save New Initiative">
	</div>	
	<input type="hidden" name="eventname" id="eventname" value="initiativeAdded">		
	</form>
</fieldset>	
	
</div>

<br>
<script>
	
	$(function() {
		$( "##initiativeTargetDate" ).datepicker();
	});
	
	$( '##frm_initiativeNew' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'initiatives_find';		
		$.callUri(uri,object);						 
		return false;		
	});
	$(document).bind('initiativeAdded', function() {
		var uri = '/initiative/find';
		var displayContext = 'initiatives_find';					
		var object = {DISPLAYCONTEXT:displayContext};
		$.callMvc(uri,object);		
	});	
</script>

</cfoutput>

</body>
