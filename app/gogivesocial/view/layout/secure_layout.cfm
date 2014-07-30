<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org">
<head>
<cfinclude template="/view/layout/common/secure_full_head.cfm" />
</head>
<body>
<div id="headerwrap">
  <header id="mainheader" class="bodywidth"> <img src="/public/images/logo.png" alt="Logo" class="logo" />
    <hgroup id="websitetitle">
      <a href="/" title="Home"><h1>Go<span class="bold" style="color:red;">Give</span>Social<br><span style="float:right;color:red;font-size:12px;">Beta</span></h1></a>
      <h2 style="float:left;">Social Awareness</h2> <!--- Social Funding... --->
    </hgroup>
    <nav>
      <ul>
        <li class="current_page_item" tab="home" id="tab_home"><a href="/" title="Home">Home</a></li>
		<li rel="/initiatives/search" tab="findinitiatives" displayContext="page" id="tab_findinitiatives"><a href="##">Initiatives</a></li>				
		<li rel="/account/new" tab="getstarted" id="tab_getstarted" displayContext="page"><a href="##">Get Started</a></li>		
		<li><a href="/pricing/index">Pricing</a></li>
		<li rel="/account/login" tab="login" id="tab_login" displayContext="page"><a href="##">Login</a></li>				
      </ul>
    </nav>
  </header>
</div>	

<span id="page"><plait:body /></span>

<cfinclude template="/view/layout/common/footer.cfm" />	

</body>
</html>