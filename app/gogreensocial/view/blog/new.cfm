<plait:use layout="none" />
<body>
<cfoutput>
<div class="form_control">		
	<form id="frm_blogNew" action="/blog/save" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">
	<div class="form_control">
		<label>Subject:</label><br>
		<input type="text" name="po:#reply.blogType#Blog[subject]" />			
	</div>
	<div class="form_control">
		<label>Body:</label><br>
		<textarea name="po:#reply.blogType#Blog[body]"></textarea>			
		<input type="submit" name="submit" id="submit" value="save new blog">
	</div>				
	<input type="hidden" name="eventname" id="eventname" value="blogAdded">
	<cfif isdefined("reply.initiativeId")>
		<input type="hidden" name="po:#reply.blogType#Blog[initiativeId]" value="#reply.initiativeId#" />
	</cfif>
	<input type="hidden" name="o:user[ID]" value="#session.user.id()#" />
	</form>
</div>
<br><br>
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
