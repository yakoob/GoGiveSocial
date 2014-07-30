<cfparam name="form.cfcommons_security_username" default="" />
 
<html>

	<head>
		<title>Access Denied</title>
	</head>
	
	<body>
	
		<cfoutput>
		<form name="cfcommons_default_login" action="#cgi.script_name##exception.extendedInfo#" method="post">
		<input type="hidden" name="cfcommons_security_login_redirect" value="#cgi.script_name##cgi.path_info#?#cgi.query_string#" />
		<table border="0">
			<tr>
				<td colspan="2" style="color:##FF0000;">
					<strong>#exception.message#</strong> <br />
					#exception.detail# <br />
				</td>
			</tr>	
			<tr>
				<td>Username:</td>
				<td><input type="text" name="cfcommons_security_username" value="#form.cfcommons_security_username#" /></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type="password" name="cfcommons_security_password" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" value="Login" /></td>
			</tr>
		</table>
		</form>
		</cfoutput>
	
	</body>

</html>