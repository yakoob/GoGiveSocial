<plait:use layout="none" />
<html>
	<cfoutput>
	<body>		
	<div id="message_new_form"></div>	
	<cfif arraylen(reply.messages)>		
		<table cellspacing="0" cellpadding="0px" bgcolor="##FFF8DC" width="100%" border="0">
		<tr>
			<td>
			<table cellspacing="0" cellpadding="4px" bgcolor="##FFF8DC" width="100%" border="0">
				<tr bgcolor="##887450" style="color:##FFF">
					<th>Date</th>
					<th>Subject</th>
					<th>From</th>
					<th>To</th>
				</tr>
				<cfset cnt = 0>
				<cfloop array="#reply.messages#" index="message">
				<cfset cnt++>		 	
				<tr <cfif !cnt mod 2> bgcolor="##FFF" </cfif>>				
					<cfoutput>
					<td><b>#dateformat(message.date(),"medium" )# #timeformat(message.date(), "short")#</b></td>
					<td>#message.getSubject()#</td>
					<td>#message.userFrom().firstname()# #message.userFrom().lastname()#</td>
					<td>#message.userTo().firstname()# #message.userTo().lastname()#</td>				 
					</cfoutput>
				</tr>
				</cfloop>
			</table>				
			</td>
		</tr>
		</table>

				
	<cfelse>
		no messages...
	</cfif>
	</body>
	</cfoutput>
</html>


