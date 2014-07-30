<plait:use layout="none" />
<html>
	<cfoutput>
	<body>		
	<div id="initiative_new_form"></div>
	
	<cfif arraylen(reply.initiatives)>		
		<ul>
		<cfloop array="#reply.initiatives#" index="initiative">		 	
		<fieldset>
		<cfinclude template="/view/initiative/contribution_summary.cfm" >		
		<br>
		</fieldset>
		<br>
		</cfloop>
		</ul>		
	<cfelse>
		no initiatives match your criteria...
	</cfif>
	
		
	<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>		
	<script type="text/javascript"> 
	$(document).ready(function() {		 
		$('.workload').workload();			
	});
	</script> 	
	

	</body>
	</cfoutput>
</html>


