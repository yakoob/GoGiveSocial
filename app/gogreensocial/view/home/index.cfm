<plait:use layout="layout" />

<head>
	<title> - Providing technology to empower people to save our planet through social funding...</title>
	<script type="text/javascript" src="/public/javascript/jquery.nivo.slider.pack.js"></script>
<style type="text/css" media="screen">
		#slider {
		    width: 610px; /* important to be same as image width */
		    height: 300px; /* important to be same as image height */
		    position: relative; /* important */
			overflow: hidden; /* important */
		}
		#sliderContent {
		    width: 610px; /* important to be same as image width or wider */
		    position: absolute;
			top: 0;
			margin-left: 0;
		}
		.sliderImage {
		    float: left;
		    position: relative;
			display: none;
		}
		.sliderImage span {
		    position: absolute;
			font: 10px/15px Arial, Helvetica, sans-serif;
		    padding: 10px 13px;
		    width: 384px;
		    background-color: #000;
		    filter: alpha(opacity=70);
		    -moz-opacity: 0.7;
			-khtml-opacity: 0.7;
		    opacity: 0.7;
		    color: #fff;
		    display: none;
		}
		.clear {
			clear: both;
		}
		.sliderImage span strong {
		    font-size: 14px;
		}
		.top {
			top: 0;
			left: 0;
		}
		.bottom {
			bottom: 0;
		    left: 0;
		}
		ul { list-style-type: none;}
	</style>

	<script type="text/javascript">
	    $(document).ready(function() {
	        $('#slider').s3Slider({
	            timeOut: 20000
	        });
	    });
	</script>
</head>

<body>	


<div id="main">
	<div id="content">				
		<fieldset>
		<legend>Did you know?</legend>
		<div id="slider">
		    <ul id="sliderContent">
		        <li class="sliderImage">
		            <a href="/treepeople"><img src="/public/images/slides/tree_people_slide.png" alt="1" /></a>
		            <span class="top"><strong>TreePeople</strong><br />An environmental nonprofit that unites the power of trees, people and technology to grow a sustainable future for Los Angeles.</span>
		        </li>		        
		        <div class="clear sliderImage"></div>
		    </ul>
		</div>		
		</fieldset><br>
		
		<fieldset>
		<legend>Did you know?</legend>
		<p><b>With over 295 billion dollars raised in the USA in 2010, wouldn't it be nice to have the most comprehensive access to donors?</b></p>		
		<p>Organizations that use online tools raise 6 times more than offline only...</p>  
		<span style="display:block; float:left;">	
			<cfchart show3d="true" 
				format="png"			
				scalefrom="0"
				scaleto="290"
				dataBackgroundColor="f4f4f4"
				backgroundcolor="f4f4f4"	  
				chartwidth="150"
				chartheight="150"
				pieslicestyle="sliced">
					<cfchartseries
			             type="pie"			             			            
						 colorlist="yellow,Green">				
					
					<cfchartdata item="Offline" value="49">
					<cfchartdata item="Online" value="246" >						
				</cfchartseries>
			</cfchart>
		</span>
		<p>An online presence is essential but tapping into social media is critical as well.</p>
		<p>Social media tools increase online fundraising efforts by 40 percent.</p>
		<p>Friends refer friends.  50 percent of online donations occur as a result of a personal referral. Tap into their virtual friends on all the popular social networks.</p>
		<p>The average person has 120 Facebook friends and 60 Twitter followers.  Each communication could be worth as much as 8 dollars. </p>
		<p><b>Go<span style="color:green">Green</span>Social</b> provides the most comprehensive access to donors and volunteers.				
		<p><b>We provide the tools; you provide the passion. Together, we can make a difference.</b></p>
		</fieldset>
		
		<cfloop array="#reply.blogs#" index="blog">
		<cfoutput>
		<br>
		<fieldset>	
		<legend><cfoutput>#blog.subject()#</cfoutput></legend>							
		<cfif len(blog.metaData())><p class="meta"><b><cfoutput>#blog.metaData()#</cfoutput></b></p></cfif>								
		<cfif len(blog.body()) >
		<div class="entry">	
			#blog.body()#													
			<div id="displayComments_#blog.id()#">
				<div class="links">						
					<div style="float:left;">
						<span rel="/blog/comment/<cfoutput>#blog.id()#</cfoutput>" id="comments-href_#blog.id()#" class="comments">Comments <cfoutput>#arraylen(blog.comment())#</cfoutput></span>		
					</div>						
				</div>
				<br><br>										
			</div>					
		</div>
		</cfif>
		</fieldset>		
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

	<div id="sidebar" style="padding-left: 10px;">		
		<fieldset>	
		<legend>Search Initiatives</legend>		
		<input type="text" rel="/initiative/partial" name="frm_search_initiatives" id="frm_search_initiatives" value="Search Initiatives" >
		</fieldset>
		<br>
		<div id="initiative_partial_list"><cfinclude template="/view/initiative/partial_list.cfm"></div>						
								
	</div>
</div>




</body>
