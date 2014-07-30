<plait:use layout="none" />
<body>

<cfoutput>
<div class="form_control">		
	<form id="frm_messageNew" action="/message/save" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">		
	<div class="form_control">
		<label>Subject:</label><br>
		<input type="text" name="po:webmessage[subject]" />			
	</div>	
	<div class="form_control">
		<label>Description:</label><br>
		<textarea name="po:webmessage[body]"></textarea>			
		<input type="submit" name="submit" id="submit" value="send">
	</div>				
	<input type="hidden" name="po:webmessage[to]" value="#reply.to#">
	<input type="hidden" name="eventname" id="eventname" value="messageSent">	
	</form>
</div>
<br>
<script>
		
	$( '##frm_messageNew' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'myMessages';		
		$.callUri(uri,object);						 
		return false;		
	});
	$(document).bind('messageSent', function() {
		alert("message sent");		
	});	
</script>

</cfoutput>

</body>
