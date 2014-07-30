<cfoutput>			
<section id="accountright">
	<fieldset>	
	<legend>My Account</legend>
	<article>
	<header><h5><li id="accountUpdateLink" rel="/account/update" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/app_48.png" width="22px"> <a href="##">Profile</a></li></h5></header> 
	</article>
	<article>
	<header><h5><li id="accountInitiativeLink" rel="/myinitiative/#session.user.id()#" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/app_48.png" width="22px"> <a href="##"><b>Initiatives</b></a></li></h5></header> 
	</article>
	<article>
	<header><h5><li id="accountMessagesLink"  rel="/message/index" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/mail_48.png" width="22px"> <a href="##">Messages</a></li></h5></header> 
	</article>
	<article>
	<header><h5><li id="accountFriendsLink"  rel="/account/friends" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/users_two_48.png" width="22px"> <a href="##">Partners</a></li></h5></header> 
	</article>
	<article>
	<header><h5><li id="accountBlogLink"  rel="/blog/search/user" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/speech_bubble_48.png" width="22px"> <a href="##">Blogs</a></li></h5></header> 
	</article>
	<article>
	<header><h5><li id="accountEventsLink"  rel="/account/events" tab="home" displayContext="displayMyAccountNavContent_#session.user.id()#"><img src="/public/images/icons/event.png" width="22px"> <a href="##">Events</a></li></h5></header> 
	</article>
	</fieldset>	
</section>
<script>
	jQuery(document).ready(function() {
		$('##accountInitiativeLink').trigger('click');
		// alert("click");
	});		
</script>			
</cfoutput>	
		
			