<plait:use layout="none" />
<html>
<body>	

<div id="main">
	<cfoutput>
	<div id="content">			
		<fieldset>	
		<legend>GoGreen Initiatives</legend>				
		<div class="post">													
			<input type="text" rel="/initiative/find" name="frm_search_initiatives" id="frm_search_initiatives" value="Search for more Initiatives">
			<a href="javascript:void(0);" rel="/initiative/new" id="initiativeNew-href"><img src="/public/images/icons/add_16.png" border="0"><b>Create a New Initiative</b></a><br><br>				
			<div id="initiatives_find"><cfinclude template="/view/initiative/find.cfm"></div>					
		</div>
		</fieldset>
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
		var object = {DISPLAYCONTEXT:displayContext,USERID:'#session.user.id()#'};			
		$.callMvc(uri,object);				
	});			

					
	</script>
	
	
	<cfinclude template="/view/training/sidebar.cfm" />		
				
	
	</cfoutput>			
</div>

</body>
</html>


