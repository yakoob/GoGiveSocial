<plait:use layout="none" />

<cfsavecontent variable="receiptTemplate"><cfinclude template="/view/payment/donation_receipt_template.cfm" ></cfsavecontent>

<body>	

<div id="main">
<div id="content">

<div class="post">				
<h2 class="title">Donation Receipt</h2>				
<div class="entry">		
<cfoutput>#ParagraphFormat(receiptTemplate)#</cfoutput>
</div>
</div>	
</div>
</div>

<cfinclude template="/view/training/sidebar.cfm" />				

</body>
