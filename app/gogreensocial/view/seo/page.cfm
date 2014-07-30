<plait:use layout="layout" />
<cfoutput>		

<plait:use layout="none" />

	<head>		
	<meta name="robots" content="index, follow" />
	<meta name="description" content="#reply.seopage.description()#" />
	<meta name="keywords" content="#reply.seopage.keywords()#" />
	<link rel="canonical" href="http://#lcase(request.app.url)#/#reply.seopage.page()#" /> 
	<title> - #reply.seopage.title()#</title>		
	</head>	
	
	<body>	
	
	<div id="main">
		<div id="content">
			
			<div class="post">				
				<h2 class="title">#reply.seopage.title()#</h2>				
				<div class="entry">						
				<cfinclude template="/view/seo/body.cfm">								 
				</div>
			</div>	
		</div>
	</div>
	
	<cfinclude template="/view/training/sidebar.cfm" />				
	
	</body>



</cfoutput>