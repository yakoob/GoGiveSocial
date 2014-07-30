<cfset initiative = reply.initiative />
<cfset iDescribe.workload = false />
<cfset iDescribe.textLength = 50 />
<fieldset style="width:275px;padding:10px;">
<cfoutput><img src="#request.app.http##request.app.url#/public/images/logo_small.png" width="25px"></cfoutput>
<cfinclude template="/view/initiative/contribution_summary.cfm" >
<br>
</fieldset>				
