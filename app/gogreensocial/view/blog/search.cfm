<plait:use layout="none" />
<body>
<cfoutput>

<cfscript>
	uuid = createUUID();
	uuid = replace(uuid, "-", "", "all");
</cfscript>

<div id="displayBlog_#uuid#">	
	<div>			
		<b style="float:right;"><a style="color:##516C00; font-size:14px" href="javascript:void(0);" rel="/blog/new" id="blogNew-href_#uuid#"><img src="/public/images/icons/add_16.png" border="0">Create a Blog Entry</a></b>		
	</div>	
	
	<div id="displayBlogNew_#uuid#"></div>

	<div class="entry">	
		<cfif !arraylen(reply.blog)>
			No blog entries found...
		</cfif>
								
		<cfloop array="#reply.blog#" index="blog">
		
		<div class="post">				
			<h2 class="title">#blog.subject()#</h2>		
			<p class="meta"><b>posted by <b>#blog.user().firstname()#</b> on #dateformat(blog.date(),"full")# #timeformat(blog.date(),"full")#</b></p>				
			<div class="entry">	
				#blog.body()#															
				<div id="displayComments_#blog.id()#">						
					<div class="links">							
						<div style="float:right;">
							<a href="javascript:void(0);" rel="/blog/comment/#blog.id()#" id="comments-href_#blog.id()#" class="comments">Comments #arraylen(blog.comment())#</a>
						</div>						
					</div>
					<br><br>						
				</div>
			</div>
		</div>
		
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
	
	</div>	
</div>
</cfoutput>
</body>
