<plait:use layout="none" />
<html>
	<cfoutput>
	<body>	
	<cfloop array="#reply.initiatives#" index="initiative">

		<cfset iDescribe.textLength = 60 />			
		<fieldset>
		<cfinclude template="/view/initiative/contribution_summary.cfm" >
		</fieldset>	
		<br>
	</cfloop>
	
		
	<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>		
	<script type="text/javascript"> 
	$(document).ready(function() {		 
		$('.workload').workload();			
	});
	</script> 	

		
		
	</body>
	</cfoutput>
</html>


