<plait:use layout="none" />
<body>
<cfoutput>

<cfscript>
	uuid = createUUID();
	uuid = replace(uuid, "-", "", "all");
</cfscript>

<div id="displayBlog_#uuid#">	

	<fieldset>		
	<legend>Blog Roll</legend>

	<a href="javascript:void(0);" rel="/blog/new" id="blogNew-href_#uuid#" class="findoutmore" title="New Blog" style="float:right;">Create a Blog Entry</a>
	
	<div style="clear:both;">&nbsp;</div>
	
	<p><div id="displayBlogNew_#uuid#"></div></p>


	<cfif !arraylen(reply.blog)>					
		<p>No blog entries found...</p>		
	</cfif>
						
	<cfloop array="#reply.blog#" index="blog">	
	
	<fieldset>		
		<fieldset style="padding:15px; ">		
		<legend><img src="/public/images/profile_unknown.png" width="30" height="30"></legend>	
		<h2 class="title"  style="color:##4086C6; float:left;">#blog.subject()#</h2> <span  style="color:##4086C6; float:right;">posted by <b>#blog.user().firstname()#</b> on <b>#dateformat(blog.date(),"full")#</b></span>		
		</fieldset>												
		<blockquote style="padding:15px;">			
			#blog.body()#
		</blockquote>															
		<div id="displayComments_#blog.id()#">		
			<p style="float:right;"><a href="javascript:void(0);" rel="/blog/comment/#blog.id()#" id="comments-href_#blog.id()#" class="findoutmore" title="View/Add Comments">Comments #arraylen(blog.comment())#</a></p>		
		</div>
	</fieldset>
	<br>
	<script>	
		$('##comments-href_#blog.id()#').click( function(){		
			var uri = $( this ).attr( 'rel' );
			var displayContext = 'displayComments_#blog.id()#';					
			var object = {DISPLAYCONTEXT:displayContext,TYPE:'#reply.blogtype#'};
			$.callUri(uri,object);				
		});		
		$(document).bind('blogCommentAdded', function() {
			$('##comments-href_#blog.id()#').trigger('click');
		});																		
	</script>	
		
	</cfloop>
			
	<script>
		$('##blogNew-href_#uuid#').click( function(){		
			var uri = $( this ).attr( 'rel' );
			var displayContext = 'displayBlogNew_#uuid#';								
			var object = {DISPLAYCONTEXT:displayContext,UUID:'#uuid#',TYPE:'#reply.blogtype#'<cfif isdefined("reply.INITIATIVEID")>,INITIATIVEID:'#reply.INITIATIVEID#'</cfif><cfif reply.blogType eq "user">,USERID:'#session.user.id()#'</cfif>};				
			$.callMvc(uri,object);				
		});			
	</script>

	</fieldset>		

	
</div>	

</cfoutput>
</body>
