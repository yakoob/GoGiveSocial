<component output="true">
	<cffunction access="public" name="display" returntype="any" output="true">
		<cfargument name="infoPath" required="false" type="string" default=""> 
		<cfargument name="summary" required="false" type="string" default="">
		<cfargument name="description" required="false" type="string" default="">
		<cfset var res = "" />		
		<cfsavecontent variable="res"><div id="fb-root"></div>
			<script>					
			window.fbAsyncInit = function() {
			  //Replace appId with your own
			  FB.init({appId: '#request.facebook.api.key#', status: true, cookie: true,
			           xfbml: true});
			};
			(function() {
			var e = document.createElement('script'); e.async = true;
			e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
			document.getElementById('fb-root').appendChild(e);}());			
			
			function emailinvite(){		
				var subject=encodeURIComponent("Please help with our Initiative...");
				var body=encodeURIComponent("#application.invoke.String().removeHtml(arguments.summary)#\n\n#request.app.name#\n#request.app.http##lcase(request.app.url)##arguments.infoPath#");				
				window.open('mailto:?subject='+subject+'&body='+body);
			}								
			</script>
			<script src="#request.app.http#platform.linkedin.com/in.js" type="text/javascript">api_key: #request.linkedin.api.key#</script>								
			<p><i>"Please share this Initiative with your friends on all of the following social networks.  It's quick & easy and will compound our fundraising efforts."</i></p><br>			
			<fb:like href="#request.app.http##lcase(request.app.url)##arguments.infoPath#" send="true" width="450" show_faces="false" font="lucida grande"></fb:like>						  	
			<br>		
			<a href="#request.app.http#twitter.com/share" class="twitter-share-button"
				data-url="#request.app.http##lcase(request.app.url)##arguments.infoPath#"
				data-text="#arguments.summary#"
				data-related="#request.app.name#:#arguments.summary#"
				data-count="none">Tweet</a>							
			<script type="IN/Share" data-url="#request.app.http##lcase(request.app.url)##arguments.infoPath#"></script>	
			<script type="text/javascript" src="#request.app.http#platform.twitter.com/widgets.js"></script>
			<a href="javascript:emailinvite();"><img width="20px" src="/public/images/icons/email_icon.jpg" title="Email" border="0"></a>&nbsp;							
			<g:plusone size="medium" annotation="inline" width="120"></g:plusone>
			<script type="text/javascript">
			  (function() {
			    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
			    po.src = '#request.app.http#apis.google.com/js/plusone.js';
			    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
			  })();			  			 
			</script>																		
		</cfsavecontent>		
		<cfreturn res />		
	</cffunction>

	<cffunction access="public" name="metadata" returntype="any" output="true">
		<cfargument name="name" required="true" type="string" default=""> 		
		<cfargument name="description" required="false" type="string" default="">
		<cfargument name="image" required="false" type="string" default="#request.app.http##lcase(request.app.url)#/public/images/logo.png">
		<cfargument name="url" required="false" type="string" default="#request.app.http##lcase(request.app.url)#">		
		<cfset var res = "" />		
		<cfsavecontent variable="res"><!--- Start Social MetaData --->
			<meta property="og:title" content="#arguments.name#"/> 
			<meta property="og:type" content="non_profit"/> 
			<meta property="og:image" content="#arguments.image#"/> 
			<meta property="og:url" content="#arguments.url#"/> 
			<meta property="og:site_name" content="#request.app.name#"/> 
			<meta property="fb:app_id" content="#request.facebook.api.key#"> 
			<meta property="og:description" content="#arguments.description#"/>
			<meta itemprop="name" content="#arguments.name#">
			<meta itemprop="description" content="#arguments.description#">
			<meta itemprop="image" content="#arguments.image#">
			<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>
			<script type="text/javascript" src="/public/javascript/fileuploader.js"></script>	
			<!--- End Social MetaData --->
		</cfsavecontent>		
		<cfreturn res />		
	</cffunction> 		

</component>