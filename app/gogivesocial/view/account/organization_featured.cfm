<plait:use layout="none" />
<cfoutput>
<body>		
<div style="float:left; width:85px; padding:2px;" >
	<a href="#request.app.http##request.app.url#/#lcase(reply.account.urlPath())#"><img src="#reply.account.getProfileImage()#"></a><br>				
	<!--- <a href="https://#request.app.url#/account/#reply.account.id()#/donate" class="donate" style="width:96%;text-align:center;font-size:1.4em;padding:5px 2px 5px 2px;">Donate</a> --->
</div>
<div style="float:right; width:200px;">
	<a href="#request.app.http##request.app.url#/#lcase(reply.account.urlPath())#"><b style="text-transform:capitalize;">#reply.account.name()#</b></a><br>
	<p>#left(reply.account.mission(),100)#<cfif len(reply.account.mission()) GT 100>...</cfif></p> 	
</div>					
</div>
</body>
</cfoutput>



