<plait:use layout="member" />
<html>
	<title>My Account</title>
		
	<body>	
	
	<div id="main">

		<cfoutput>
		<div id="sidebar" style="float:left;margin-left:15px; width:260px;">
			<ul>
				<li>										
					<h2>#session.user.firstname()# #session.user.lastname()#</h2>													
					<!--- <img src="/public/images/profile_unknown.png" width="30px"> --->
					<cfif reply.account.hasAddress()>					
					#reply.account.address()[1].city()#, #reply.account.address()[1].state()# <br>
					</cfif>										
					<div style="padding:10px">						
					<ul>					
					<li id="accountUpdateLink" rel="/account/update" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/app_48.png" width="22px"> <a href="##">Edit My Profile</a></li>					
					<li id="accountInitiativeLink" rel="/myinitiative/#session.user.id()#" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/app_48.png" width="22px"> <a href="##"><b>My Initiatives</b></a></li>					
					<li id="accountMessagesLink"  rel="/message" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/mail_48.png" width="22px"> <a href="##">My Messages</a></li>					
					<li id="accountFriendsLink"  rel="/account/friends" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/users_two_48.png" width="22px"> <a href="##">My Friends</a></li>
					<li id="accountBlogLink"  rel="/blog/search/user" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/speech_bubble_48.png" width="22px"> <a href="##">My Blogs</a></li>
					<li id="accountEventsLink"  rel="/account/events" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/event.png" width="22px"> <a href="##">Events</a></li>
					</ul>					
					</div>
					<br>																		
				</li>
			</ul>			
										
		</div>
		
		<div id="content" style="width:705px">			
			<div class="post">				
				<div id="displayMyAccountNavContent_#session.user.id()#"></div>
				
			</div>			
		</div>	
			

		<script>
			jQuery(document).ready(function() {
				$('##accountInitiativeLink').trigger('click');
				// alert("click");
			});		
		</script>




			
		</cfoutput>			
	</div>


	</body>
</html>

