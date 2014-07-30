<fieldset style="width:300px;">	
<cfoutput>
<div>
	<div style="float:left; width:85px; padding:2px;" >
		<a href="#request.app.http##request.app.url#/#lcase(account.urlPath())#"><img src="#request.app.http##request.app.url##account.getProfileImage()#" width="65px"></a><br>				
		<a href="http://#request.app.url#/account/#account.id()#/donate" class="donate" style="width:96%;text-align:center;font-size:1.4em;padding:5px 2px 5px 2px;">Donate</a>
	</div>
	<div style="float:right; width:200px;">
		<a href="#request.app.http##request.app.url#/#lcase(account.urlPath())#"><b style="text-transform:capitalize;">#account.name()#</b></a><br>
		<p>#left(account.mission(),100)#<cfif len(account.mission()) GT 100>...</cfif></p> 	
	</div>					
</div>	
</cfoutput>
</fieldset>	