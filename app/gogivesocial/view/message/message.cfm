<plait:use layout="none" />
<html>
<body>	
			
<div id="main">
	<cfoutput>
	<div id="content" style="width:100%">			
		<fieldset>	
		<legend>My Messages</legend>	
		<div class="post">							
			<div class="entry">											
				<a href="javascript:void(0);" rel="/message/new" id="messageNew-href"><img src="/public/images/icons/mail_write_48.png" border="0" title="Compose New Message" width="25px"></a>
				&nbsp;
				<a href="javascript:void(0);" rel="/message/new" id="messageNew-href"><img src="/public/images/icons/mail_forward_48.png" border="0" title="Reply" width="25px"></a>
				&nbsp;
				<a href="javascript:void(0);" rel="/message/new" id="messageNew-href"><img src="/public/images/icons/mail_reply_48.png" border="0" title="Reply" width="25px"></a>									
				&nbsp;
				<a href="javascript:void(0);" rel="/message/new" id="messageNew-href"><img src="/public/images/icons/mail_delete_48.png" border="0" title="Reply" width="25px"></a>				
				<br>				
				<div id="myMessages"><cfinclude template="/view/message/list.cfm"></div>			
			</div>	
		</div>			
		</fieldset>		
	</div>
	
	<script>		
	$('##messageNew-href').click( function(){		
		var uri = $( this ).attr( 'rel' );
		var displayContext = 'message_new_form';								
		var object = {DISPLAYCONTEXT:displayContext};		
		$.callMvc(uri,object);				
	});			
	</script>
				
	</cfoutput>			
</div>

</body>
</html>


