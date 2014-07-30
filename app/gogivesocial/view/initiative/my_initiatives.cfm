<plait:use layout="none" />
<html>
<body>	
			



<!--- 
<fieldset>	
<legend>Search</legend>										
<input type="text" rel="/initiative/find" name="frm_search_initiatives" id="frm_search_initiatives" value="Search for more Initiatives" style="width:380px;">			
<p><a href="javascript:void(0);" rel="/initiative/new" id="initiativeNew-href" class="findoutmore">Create a New Initiative</a></p>
</fieldset>
--->


<div id="maincontent" class="bodywidth" style="width:790px;">

	<cfoutput>

	<fieldset>	
	<legend>My Initiatives</legend>
	<p><a href="javascript:void(0);" rel="/initiative/new" id="initiativeNew-href" class="findoutmore">Create a New Initiative</a></p><br><br>								
	<p>	<div id="initiatives_find"><cfinclude template="/view/initiative/find.cfm"></div></p>			
	</fieldset>
						
	<script>		
	$('##frm_search_initiatives').click(function(){
		$('##frm_search_initiatives').val("");	
		// $('##frm_search_initiatives').trigger('keyup');	
	});	
	
	$('##frm_search_initiatives').keyup( function(){		
		var uri = $( this ).attr( 'rel' );		
		var displayContext = 'initiative_partial_list';					
		var object = {DISPLAYCONTEXT:'initiatives_find',SEARCHSTRING:this.value};
		$.callMvc(uri,object);								 
	});

	$('##initiativeNew-href').click( function(){		
		var uri = $( this ).attr( 'rel' );
		var displayContext = 'initiative_new_form';								
		var object = {DISPLAYCONTEXT:displayContext};		
		$.callMvc(uri,object);				
	});			

	</script>
				
	</cfoutput>			
</div>

</body>
</html>


