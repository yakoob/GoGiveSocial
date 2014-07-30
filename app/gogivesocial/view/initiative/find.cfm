<plait:use layout="none" />
<html>
	<cfoutput>
	<body>		
	<div id="initiative_new_form"></div><br>
	
	<cfif arraylen(reply.initiatives)>		
		<cfloop array="#reply.initiatives#" index="initiative">		 			
		<fieldset>
		<cfinclude template="/view/initiative/contribution_summary.cfm" >		
		<br><br>				
		<a href="/initiative/#initiative.id()#"><img src="/public/images/icons/ok.png"  width="15" border="0"> <b>Donate Today!</b></a>		
		<br>
		</fieldset>
		<br>
		</cfloop>
		
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


