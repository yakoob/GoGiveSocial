<plait:use layout="none" />
<html>
<body>	
			
<div id="main">
	<cfoutput>
	<div id="content" style="width:100%">			
		<div class="post">				
			<h2 class="title">My Initiatives</h2>	
			<div class="entry">
										
				<img src="/public/images/icons/search_48.png" width="20px">
				<input type="text" rel="/initiative/find" name="frm_search_initiatives" id="frm_search_initiatives" value="Search for more Initiatives" style="width:380px;"> 
				<a href="javascript:void(0);" rel="/initiative/new" id="initiativeNew-href"><img src="/public/images/icons/add_16.png" border="0">Create a New Initiative</b></a><br><br>
					
				<div id="initiatives_find"><cfinclude template="/view/initiative/find.cfm"></div>
			
			</div>	
		</div>			
	</div>
	
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


