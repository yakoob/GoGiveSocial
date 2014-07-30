<plait:use layout="no_layout" />
<body>
<cfoutput>

<div class="links">	
	<div style="float:right;">
		<a href="javascript:void(0);" rel="/blog/comment/<cfoutput>#reply.blogId#</cfoutput>" id="comments-href_#reply.blogId#" class="findoutmore">Comments <cfoutput>#arraylen(reply.comments)#</cfoutput></a>		
	</div>						
</div>
<br>
<br>
<br>
<br>
<fieldset>	
<legend>Add Comment</legend>
<div id="content">
	<div class="post"> 
	<cfset cnter = 0>
	<cfloop array="#reply.comments#" index="comment">
	<cfset cnter = cnter + 1>	
	<fieldset>			
		posted by <b>#comment.user().firstname()#</b> on <b>#dateformat(comment.date(),"full")#</b>
	</fieldset>			
	<blockquote style="padding:10px;">
		<p style="margin-left:20px; margin-right:15px;">#comment.body()#</p>
	</blockquote>
	</cfloop>		
	</div>
</div>

<div class="form_control">		
	<form id="frm_blogComment_#reply.blogId#" action="/blog/comment/save" method="post" style="background-color:##fffffff; padding:0px; margin:0px;">
	<textarea style="width:95%" name="po:BlogComment[body]"></textarea>	
	<br>
	<a title="Login" class="findoutmore" onclick="javascript:$('##frm_blogComment_#reply.blogId#').submit();">add comment</a>
	<input type="hidden" name="po:BlogComment[userID]" value="#session.user.id()#">
	<input type="hidden" name="po:BlogComment[blogID]" value="#reply.blogId#">
	<input type="hidden" name="eventname" id="eventname" value="blogCommentAdded">
	</form>
</div>
</fieldset>
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
