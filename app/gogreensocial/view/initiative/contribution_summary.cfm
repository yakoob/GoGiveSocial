<cfparam name="iDescribe.statsOnly" default="false" >
<cfparam name="iDescribe.textLength" default="300" >
<cfparam name="iDescribe.workload" default="true" >

<cfoutput>
<cfif !iDescribe.statsOnly>
	<a href="#request.app.http##request.app.url#/initiative/#initiative.id()#"><b>#initiative.name()#</b></a>
	<cfif val(iDescribe.textLength)><p style="margin:10px;">#left(initiative.summary(), iDescribe.textLength)#<cfif len(initiative.summary()) gt iDescribe.textLength>...</cfif></p><cfelse><br></cfif>	
</cfif>
<cfif val(initiative.getLedgerSummary(initiative.ledger().id()).donationNeeded)>
	<img src="#request.app.http##request.app.url#/public/images/icons/money.png" width="20" border="0"> Donations: <b>#NumberFormat( initiative.getLedgerSummary(initiative.ledger().id()).donationBooked, "$" )# / #NumberFormat( initiative.getLedgerSummary(initiative.ledger().id()).donationNeeded, "$" )#</b><br>
<cfelseif val(initiative.getLedgerSummary(initiative.ledger().id()).volunteerBooked)>
	<img src="#request.app.http##request.app.url#/public/images/icons/money.png" width="20" border="0"> Donations: <b>#NumberFormat( initiative.getLedgerSummary(initiative.ledger().id()).donationBooked, "$" )#</b><br>									
</cfif>
<cfif val(initiative.getLedgerSummary(initiative.ledger().id()).volunteerNeeded)>
	<img src="#request.app.http##request.app.url#/public/images/icons/digg_48.png" width="20" border="0"> Volunteers: <b>#initiative.getLedgerSummary(initiative.ledger().id()).volunteerBooked#/#initiative.getLedgerSummary(initiative.ledger().id()).volunteerNeeded#</b>		
</cfif>																			
<cfif iDescribe.workload>
<div class="workload">				
	<div class="loader"> 
		<span class="load"></span> 
		<span class="border"></span> 
	</div>
	<span class="percentage">
		<cfif initiative.getLedgerSummary(initiative.ledger().id()).percentage EQ 1 AND val(initiative.getLedgerSummary(initiative.ledger().id()).donationBooked)>
			#initiative.getLedgerSummary(initiative.ledger().id()).donationBooked#
		<cfelse>
			#round(initiative.getLedgerSummary(initiative.ledger().id()).percentage)#%
		</cfif> 
	</span>					 
</div>	
</cfif>
</cfoutput>