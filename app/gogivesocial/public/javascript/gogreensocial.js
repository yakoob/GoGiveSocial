$(document).ready(function(){	
	
	function jeval(str){return eval('(' +  str + ')')};
	
	String.prototype.left = function(n){
		if (n < 1 ){
			return "";
		} else if (n > String(this).length){
			return this;
		} else {
			return String(this).substring(0, n);
		}
	};
	
	String.prototype.right = function(n){
		if (n < 1 ){
			return "";
		} else if (n > String(this).length){
			return this;
		} else {
			var iLen = String(this).length;
			return String(this).substring(iLen, iLen - n);
		}
	};
	
	String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ''); };
	
	Array.prototype.remove = function(from, to) {
	  var rest = this.slice((to || from) + 1 || this.length);
	  this.length = from < 0 ? this.length + from : from;
	  return this.push.apply(this, rest);
	};
	
	String.prototype.obj = function(jsonString){
		var x = jeval(this);
	 	for ( property in jsonString){
	  		x[property] = jsonString[property];
	 	};
	 	return x;
	};

	jQuery.callMvc = function(uri, eventObject){
		$('#'+ eventObject.DISPLAYCONTEXT).load(uri, eventObject);		
	}	
	
	jQuery.callUri = function(uri,eventObject){		
		// document.getElementById(eventObject.DISPLAYCONTEXT).innerHTML = "<center><img src='public/images/spinner.gif'> Loading...</center>";
		eventObject["DISPLAYMETHOD"] = eventObject["DISPLAYMETHOD"] ? eventObject["DISPLAYMETHOD"] : 'html';			
		$.post(uri + '.json', eventObject, UriCallback);	
	};
	
	function UriCallback(eventObject){
	
		// if there's a display in the response object, display it
		var response = eventObject.SEED ? eventObject.SEED : eventObject;	
		if (response.DISPLAY !== ''){
			if (response.DISPLAYCONTEXT == 'body') {
				$('body')[response.DISPLAYMETHOD](response.DISPLAY);
			} else{
				$('#'+ response.DISPLAYCONTEXT)[response.DISPLAYMETHOD](response.DISPLAY);							
			};
		};
		
		// announce the event returned by the proxy
		if ( response.EVENTNAME != ''){
			$.announce(response.EVENTNAME, response);
		};
		
	};
	
	jQuery.announce = function(event, eventObject){	  	 
	  if ( !eventObject ){
			eventObject = {};
		};
		
		if (typeof eventObject == 'string'){
			eventObject = jeval(eventObject);
		};
	
		eventObject.event = event;
		
	  	jQuery(document).trigger(eventObject.event, eventObject);
	   return this;
	};
	
	//LISTEN
	jQuery.listen = function(events, eventObject) {
		var events = events.replace(/[,' ']/g, ' ');
		events = events.replace(/\./g, '_');
		jQuery(document).bind(events, eventObject);
	   return this;
	};
		
	//SERIALIZEFORM
	jQuery.fn.serializeForm = function(_arguments){
		var _argsString = '';
		if (typeof _arguments == "object") {
			for (var prop in _arguments) {
				_argsString += '"';
				_argsString += prop;
				_argsString += '":"';
				_argsString += _arguments[prop];
				_argsString += '",';
			};
		};
		
		var formVars = $(this).serializeArray();
		var formJson = '{';
		var paragraphFormater = '';
		for (var i=0; i<formVars.length; i++){
			formJson += '"';
			formJson += formVars[i].name;
			formJson += '":"';
			paragraphFormater = formVars[i].value.replace(new RegExp( "\\n", "g" )," <br> ");		
			formJson += formVars[i].value.length ? escape(paragraphFormater) : '';
			formJson += '",';
		};
		
		if (_argsString.length) {
			formJson += _argsString;	
		};		
		formJson = formJson.replace(/\,$/,'');
		formJson += '}';	
		return jeval(formJson);
	};
	
		
	$('#frm_search_initiatives').click(function(){
		$('#frm_search_initiatives').val("");	
		$('#frm_search_initiatives').trigger('keyup');	
	});
					
	$('#frm_search_initiatives').keyup( function(){
		var uri = $( this ).attr( 'rel' );
		var displayContext = 'initiative_partial_list';					
		var object = {DISPLAYCONTEXT:displayContext,SEARCHSTRING:this.value};
		$.callMvc(uri,object);								 
	});			

	/* BEGIN **** LAYOUT **** */
    $("li").click(function () {	     	
		var uri = $( this ).attr( 'rel' );		
		var displayContext = $( this ).attr( 'displayContext' );
		// var displayContext = displayContext ? displayContext : 'page';		
		var object = {DISPLAYCONTEXT:displayContext};
		$.callMvc(uri,object);				
		$('li').each(function(index) {
			$(this).removeClass("current_page_item");			
		});		
		var tab = $( this ).attr( 'tab' );
		var tab = tab ? tab : 'home';				
		$('#tab_' + tab).addClass("current_page_item");
		return true;					
    });
	/* END **** LAYOUT **** */

	/* BEGIN **** LOGIN **** */	
	$(document).bind('loginPassed', function(event, eventObject) {		
		var uri = '/account/index';		
		window.location.replace(uri);		
	});
	
	$(document).bind('loginFailed', function(event, eventObject) {						
		var uri = '/account/login';	
		var displayContext = 'page';		
		var object = {DISPLAYCONTEXT:displayContext};
		$.callMvc(uri,object);
	});		
	/* END **** LOGIN **** */


	$(document).bind('error', function(event, eventObject) {				
		for ( e in eventObject.ERRORS){
	  		if (!isNaN(e)){				
				$.jGrowl(eventObject.ERRORS[e], { life: 5000 });				
			}
			
	 	};
					
	});		
	

	$(".asset_colorbox").colorbox({
			transition:"elastic"
		, 	width:"550"				
		,	opacity:"0.8"
		/*
		,	onOpen:function(){ alert('onOpen: colorbox is about to open'); }
		,	onLoad:function(){ alert('onLoad: colorbox has started to load the targeted content'); }
		,	onComplete:function(){ alert('onComplete: colorbox has displayed the loaded content'); }
		,	onCleanup:function(){ alert('onCleanup: colorbox has begun the close process'); }
		,	onClosed:function(){ alert('onClosed: colorbox has completely closed'); }
		*/
	});
	

});		

function loadCaptcha(){		
	var uri = '/captcha/index';	
	var displayContext = 'captchaDisplay';		
	var object = {DISPLAYCONTEXT:displayContext};
	$.callMvc(uri,object);
}	
