<plait:use layout="layout" />
<head>
	<title> &#8657; Social Awareness:</title>		
	<script type="text/javascript"> 
		$(document).ready(function(){
			var uri = '/featured/nonprofit?foo=<cfoutput>#randrange(234,234234)#</cfoutput>';		
			var displayContext = 'displayFeaturedNP';					
			var object = {DISPLAYCONTEXT:displayContext};
			$.callMvc(uri,object);		
		});		
	</script>		
</head>
	
<body>

<!--- <cfdump var="#GetHTTPRequestData()#"> --->
<br>
<!--- 
<cfif len(trim(request.app.compatible))><cfoutput>#request.app.compatible#</cfoutput></cfif>	
--->

<aside id="introduction" class="bodywidth">
	<div id="introleft">
		<fieldset>
			<legend>Our Mission</legend>	
			<h2>The Go<span style="color:red;">Give</span>Social Mission:</h2>
			<p style="padding:10px 10px 0 10px;">to provide technology empowering humanitarian intervention through social awareness...</p>
			<p><li rel="/initiatives/search" tab="findinitiatives" displayContext="page" id="tab_findinitiatives"><a href="#" title="Find Out More" class="findoutmore" style="width:96%;text-align:center;font-size:1.4em;">Start an Initiative Today!</a></li></p>
		</fieldset>
	</div>
	<div id="nonprofitright">		
		<fieldset>		
		<legend>Featured Non-Profit</legend>				
		<div id="displayFeaturedNP"></div>
		</fieldset>
	</div>
</aside>	

<div id="maincontent" class="bodywidth">

	<div id="aboutleft">	
		<cfloop array="#reply.blogs#" index="blog">
		<cfoutput>						
		<fieldset>
		<legend>Did you know?</legend>
		<p><b>With over 295 billion dollars raised in the USA in 2010, wouldn't it be nice to have the most comprehensive access to donors?</b></p>		
		<p>Organizations that use online tools raise 6 times more than offline only...</p>  
		<span style="display:block; float:left;">		
		<cfchart show3d="true" 
			format="png"
			title="The future of fundraising today..."			
			scalefrom="0"
			scaleto="290"
			dataBackgroundColor="f4f4f4"
			backgroundcolor="f4f4f4"	  
			chartwidth="150"
			chartheight="200"
			pieslicestyle="sliced">
				<cfchartseries
		             type="pie"			             			            
					 colorlist="yellow,3B7EBD">				
				<cfchartdata item="Offline" value="49">
				<cfchartdata item="Online" value="246" >						
			</cfchartseries>
		</cfchart>
		</span>
		<p>An online presence is essential but tapping into social media is critical as well.</p>
		<p>Social media tools increase online fundraising efforts by 40 percent.</p>
		<p>Friends refer friends.  50 percent of online donations occur as a result of a personal referral. Tap into their virtual friends on all the popular social networks.</p>
		<p>The average person has 120 Facebook friends and 60 Twitter followers.  Each communication could be worth as much as 8 dollars. </p>
		<p><b>Go<span style="color:red">Give</span>Social</b> provides the most comprehensive access to donors and volunteers.				
		<p><b>We provide the tools; you provide the passion. Together, we can make a difference.</b></p>
		</fieldset>
		
		
		<br>
		
		<fieldset>
		<legend>#blog.subject()#</legend>			
		#blog.body()#		
		</fieldset>	
		<div id="displayComments_#blog.id()#">
			<a rel="/blog/comment/<cfoutput>#blog.id()#</cfoutput>" id="comments-href_#blog.id()#" class="findoutmore">Comments <cfoutput>#arraylen(blog.comment())#</cfoutput></a>								
		</div>
		
		<script>		
		$('##comments-href_#blog.id()#').click( function(){					
		var uri = $( this ).attr( 'rel' );
		var displayContext = 'displayComments_#blog.id()#';					
		var object = {DISPLAYCONTEXT:displayContext};
		$.callUri(uri,object);				
		});	
		
		$(document).bind('blogCommentAdded', function() {
		$('##comments-href_#blog.id()#').trigger('click');
		});			
		</script>
		
					
		</cfoutput>
		</cfloop>
	</div>

	<section id="articlesright">	
	<fieldset>	
	<legend>Initiatives Search</legend>
	<input type="text" rel="/initiative/partial" name="frm_search_initiatives" id="frm_search_initiatives" value="Search for more Initiatives" style="width:250px;">	
	<br><br><div id="initiative_partial_list"><cfinclude template="/view/initiative/partial_list.cfm"></div>
	</fieldset>	
	</section>
	
</div>

</body>