<plait:use layout="none" />
<body>
<cfoutput>
<fieldset>		
<legend>New Blog</legend>
<div class="form_control">		
	<form id="frm_blogNew" action="/blog/save" method="post">
	<div class="form_control">		
		<label>Subject:</label>
		<input type="text" name="po:#reply.blogType#Blog[subject]" />			
	</div>
	<div class="form_control">
		<label>Body:</label>
		<textarea name="po:#reply.blogType#Blog[body]"></textarea>					
	</div>					
	<cfif isdefined("reply.initiativeId")>
		<div class="form_control">
			<label></label>
			<input type="submit" name="submit" id="submit" value="Save New Blog">			
		</div>
		<input type="hidden" name="po:#reply.blogType#Blog[initiativeId]" value="#reply.initiativeId#" />		
	</cfif>
	<input type="hidden" name="po:#reply.blogType#Blog[accountid]" value="#session.user.accountId()#" />
	<input type="hidden" name="o:user[ID]" value="#session.user.id()#" />
	<input type="hidden" name="eventname" id="eventname" value="blogAdded">
	</form>
</div>
</fieldset>
<br>	
<script>
	$( '##frm_blogNew' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'displayComments';		
		$.callUri(uri,object);						 
		return false;		
	});
	$(document).bind('blogAdded', function() {
		var uri = '/blog/search/#reply.blogType#';
		var displayContext = 'displayBlog_#reply.uuid#';					
		var object = {DISPLAYCONTEXT:displayContext<cfif isdefined("reply.initiativeId")>,INITIATIVEID:#reply.initiativeId#</cfif>};
		$.callMvc(uri,object);
	});	
</script>
</cfoutput>
</body>
