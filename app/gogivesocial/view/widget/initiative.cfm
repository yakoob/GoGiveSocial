<cfset initiative = reply.initiative />
<cfset iDescribe.workload = false />
<cfset iDescribe.textLength = 50 />
<fieldset style="width:275px;padding:10px;">
<cfoutput><img src="http://#request.app.url#/public/images/logo_small.png" width="35px"></cfoutput>
<cfinclude template="/view/initiative/contribution_summary.cfm" >
<cfoutput><a href="http://#request.app.url#/initiative/#initiative.id()#" class="donate">Donate</a></cfoutput>
<!--- <cfoutput><div style="padding: 55px 0 0 0; text-align:center;"><img src="#request.app.http##request.app.url#/public/images/logo_small.png" width="35px"> <b>Go<span class="bold" style="color:red;">Give</span>Social.com</b></div></cfoutput> --->
</fieldset>	

