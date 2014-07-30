<plait:use layout="none" />
<html>
<body>	
<br>

<div id="maincontent" class="bodywidth">

<aside id="introduction" class="bodywidth">
	<div id="introleft">   
	<fieldset>
		<legend>Initiative Search</legend>	
							
		<p><b>Find an Initiative that suits your interest.</b></p>
		<input type="text" rel="/initiative/find" name="frm_search_initiatives" id="frm_search_initiatives" value="Search for more Initiatives" style="width:380px;">
		<p><a href="javascript:void(0);" rel="/initiative/new" id="initiativeNew-href" class="findoutmore" style="width:96%;text-align:center;font-size:1.2em;">Create a New Initiative</a></p>
	</fieldset>
	</div>
	<div id="nonprofitright">		
		<fieldset>		
		<legend>Featured Non-Profit</legend>				
		<span id="display_featured_non_profit"></span>
		</fieldset>
	</div>
</aside>	



<cfoutput>
	
	<div id="aboutleft">	
							
		<div id="initiatives_find">			
			<cfinclude template="/view/initiative/find.cfm">
			<!---<cfinclude template="/view/util/record_navigation.cfm" >--->
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
		var object = {DISPLAYCONTEXT:displayContext,USERID:'#session.user.id()#'};			
		$.callMvc(uri,object);				
	});						
	</script>
	
	<script>
		$(document).ready(function(){
			var uri = '/featured/nonprofit';		
			var displayContext = 'display_featured_non_profit';					
			var object = {DISPLAYCONTEXT:displayContext};
			$.callMvc(uri,object);		
		});		
	</script>
	<cfinclude template="/view/training/sidebar.cfm" />
		
</cfoutput>
</div>


</body>
</html>


