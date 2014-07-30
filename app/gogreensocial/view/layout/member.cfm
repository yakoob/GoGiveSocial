<div id="site_ggs">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<cfoutput>
<head>
	<cfinclude template="/view/layout/common/full_head.cfm" />
</head>
<body>	
	<div id="wrapper" style="text-align: center;">					
		<div id="header">
			<div id="logo">
				<h1><a href="/"><img src="/public/images/green.png" width="60px" border="0" title="Take charge and make a difference at GoGreenSocial.com!">Go<span style="font-weight:bolder;color:##33cc00;">Green</span>Social</a><br><span style="color:##000000;font-size:16px; float:right;text-shadow: 0 0 3px ##FFFFFF;">powered by <a href="http://www.gogivesocial.com" style="color:##5A554E;"><img src="http://www.gogivesocial.com/public/images/logo_small.png" border="0">Go<span style="color:red;">Give</span>Social</a></span></h1>			
			</div>						
			<div style="float:right; margin:10px; margin-right:25px;"><a href="/account/logout">Logout</a></div>
		</div>						
					
		<div id="menu">	
		<ul>			
			<li class="current_page_item" tab="home" id="tab_home"><a href="/account/profile">My Account</a></li>			
			<li rel="/initiatives/search" tab="findinitiatives" displayContext="page" id="tab_findinitiatives"><a href="##">Initiatives</a></li>							
			<li tab="logout" id="tab_logout"><a tab="login" href="/account/logout">Logout</a></li>				
		</ul>
		</div>				
				
		<div id="page">		
			<plait:body />			
		</div>				
		
		<cfinclude template="/view/layout/common/footer.cfm" />	
				
	</div>	

</body>	
</cfoutput>
</html>
</div>