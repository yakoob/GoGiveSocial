<plait:use layout="no_layout" />
<body>
<cfoutput>

<div class="links">						
	<div style="float:right;">
		<a href="javascript:void(0);" rel="/blog/comment/<cfoutput>#reply.blogId#</cfoutput>" id="comments-href_#reply.blogId#" class="comments">Comments <cfoutput>#arraylen(reply.comments)#</cfoutput></a>		
	</div>						
</div>
<br>

<div id="content">
	<div class="post" style="width:85%"> 
	<cfset cnter = 0>
	<cfloop array="#reply.comments#" index="comment">
	<cfset cnter = cnter + 1>
	<div style="background-color:##<cfif cnter mod 2>FFF8DC<cfelse>FFF</cfif>; padding:5px;">				
		<span class="meta"> <b>#dateformat(comment.date(),"full")# - posted by #comment.user().firstname()# #comment.user().lastname()#</b></span>
		<p style="margin-left:20px; margin-right:15px;">#comment.body()#</p>
	</div>
	</cfloop>		
	</div>
</div>

<div class="form_control">		
	<form id="frm_blogComment_#reply.blogId#" action="/blog/comment/save" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">
	<textarea name="po:BlogComment[body]"></textarea>			
	<br><input type="submit" name="submit" id="submit" value="add comment" style="">
	<input type="hidden" name="po:BlogComment[userID]" value="1">
	<input type="hidden" name="po:BlogComment[blogID]" value="#reply.blogId#">
	<input type="hidden" name="eventname" id="eventname" value="blogCommentAdded">
	</form>
</div>
<br><br>

<script>
	$( '##frm_blogComment_#reply.blogId#' ).submit( function(){		
		var uri = $( this ).attr( 'action' );
		var object = $( this ).serializeForm();
		object.DISPLAYCONTEXT = 'displayComments';		
		$.callUri(uri,object);						 
		return false;		
	});

	$('##comments-href_#reply.blogId#').click( function(){		
		var uri = $( this ).attr( 'rel' );
		var displayContext = 'displayComments_#reply.blogId#';					
		var object = {DISPLAYCONTEXT:displayContext};
		$.callUri(uri,object);				
	});
</script>

</cfoutput>
</body>
