<plait:use layout="layout" />
<html>
	<cfoutput>
	<head>
		<title>#reply.title#</title>		
	</head>
	
	<body>	
		<div id="content">		

			<div class="post">			
			
				<h2 class="title">Adding features to your Initiative(s)</h2>								
				
				<div class="entry">

					<form action="#reply.formAction#" method="post" id="accountForm">			
					<p>Go<span style="font-weight:bolder;color:##33cc00;">Green</span>Social features - We provide the tools; you provide the passion. Together, we can make a difference.</p>
					<div class="form_control">														
						<blockquote style="text-align:left;">
						<input type="checkbox" name="initiative[asset]" value="full" /> <b>Full Feature Set</b> (<i>24.99/mo.</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="blog" checked="checked" /> <b>Initiative Blog</b> (<i>no charge</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="partners" checked="checked" /> <b>Initiative Partners</b> (<i>no charge</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="email" checked="checked" /> <b>Notification Emails</b> (<i>no charge</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="media" /> <b>Photos / Videos</b> (<i>2.99/mo.</i>)<br />						
						<input type="checkbox" name="initiative[asset]" value="charting" /> <b>Charting</b> (<i>5.99/mo.</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="matching" /> <b>Matching Funds</b> (<i>9.99/mo.</i>)<br />
						<input type="checkbox" name="initiative[asset]" value="assets" /> <b>Tracked Cost Assets</b> (<i>9.99/mo.</i>) Track quantity & cost of assets (people, places, materials, other) needed to accomplish your Initiatives.<br />
						<input type="checkbox" name="initiative[asset]" value="matching" /> <b>Data Export</b> (<i>9.99/mo.</i>) XLS Export & Web Services API to help you remotly access your data. (Accounting / Back Office Integration, ect...) 						
						</blockquote>
					</div>
					
					<div class="form_submit">
						<input type="button" value="#reply.submitButton#" />
					</div>
																
					</form>
			
				</div>
				
			</div>
			
		</div>
		
		<cfinclude template="/view/training/sidebar.cfm" />	
				
			
	</body>
	</cfoutput>
</html>


