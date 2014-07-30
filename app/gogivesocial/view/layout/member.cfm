<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org">
<head>
<cfinclude template="/view/layout/common/full_head.cfm" />
</head>
<body>
<div id="headerwrap">
  <header id="mainheader" class="bodywidth"> <img src="/public/images/logo.png" alt="Logo" class="logo" />
    <hgroup id="websitetitle">
      <a href="/account/index" title="Home"><h1>Go<span class="bold" style="color:red;">Give</span>Social</h1></a>
      <h2 style="float:left;">Social Funding...</h2>
    </hgroup>    
    <nav>
      <ul>		
		<li class="current_page_item" tab="home" id="tab_home"><a href="/account/index">Profile</a></li>			
		<li rel="/initiatives/search" tab="findinitiatives" displayContext="page" id="tab_findinitiatives"><a href="##">Initiatives</a></li>		
		<li tab="logout" id="tab_logout"><a tab="login" href="/account/logout">Logout</a></li>								
      </ul>
    </nav>
  </header>
</div>	

<span id="page"><plait:body /></span>

<cfinclude template="/view/layout/common/footer.cfm" />	

</body>
</html>