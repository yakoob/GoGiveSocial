<plait:use layout="none" />
<html>

	<body>	
	<cfoutput>
	
	<cfif !arraylen(reply.initiatives)>
		no records found...
	<cfelse>		
		<!---<cfinclude template="/view/util/record_navigation.cfm" ><br><br>	--->		
		<cfloop array="#reply.initiatives#" index="initiative">			
			<fieldset>
			<cfset iDescribe.textLength = 60 />			
			<cfinclude template="/view/initiative/contribution_summary.cfm" >					
			<br><br>				
			<a href="/initiative/#initiative.id()#" style="float:right;"><img src="/public/images/icons/ok.png"  width="15" border="0"> <b>Donate Today!</b></a>						
			<br>
			</fieldset>
			<br>			
		</cfloop>
		<!--- <cfinclude template="/view/util/record_navigation.cfm" > --->		
	</cfif>		
	</cfoutput>	

		
	<script type="text/javascript" src="/public/javascript/jquery.workload.js"></script>		
	<script type="text/javascript"> 
	$(document).ready(function() {		 
		$('.workload').workload();			
	});
	</script> 	


	</body>
	
	
	
</html>


