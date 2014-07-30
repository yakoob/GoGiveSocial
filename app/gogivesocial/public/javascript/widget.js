(function() {

// Localize jQuery variable
var jQuery;

/******** Load jQuery if not present *********/
if (window.jQuery === undefined || window.jQuery.fn.jquery !== '1.4.2') {
    var script_tag = document.createElement('script');
    script_tag.setAttribute("type","text/javascript");
    script_tag.setAttribute("src",
        "https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js");
    script_tag.onload = scriptLoadHandler;
    script_tag.onreadystatechange = function () { // Same thing but for IE
        if (this.readyState == 'complete' || this.readyState == 'loaded') {
            scriptLoadHandler();
        }
    };
    // Try to find the head, otherwise default to the documentElement
    (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
} else {
    // The jQuery version on the window is the one we want to use
    jQuery = window.jQuery;
    main();
}

/******** Called once jQuery has loaded ******/
function scriptLoadHandler() {
    // Restore $ and window.jQuery to their previous values and store the
    // new jQuery in our local jQuery variable
    jQuery = window.jQuery.noConflict(true);
    // Call our main function
    main(); 
}

/******** Our main function ********/
function main() { 
    jQuery(document).ready(function($) {        
       
		var ggsDestination = $( '#ggs_display_widget' ).attr( 'ggs_type' ) + '/' + $( '#ggs_display_widget' ).attr( 'ggs_id' );
		
		var css_url = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'www.gogivesocial.com/public/css/style.css';      
		var css_link = $("<link>", { 
            rel: "stylesheet", 
            type: "text/css", 
            href: css_url
        });
        css_link.appendTo('head');        	
		var jsonp_url = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'www.gogivesocial.com/widget/' + ggsDestination + '?callback=?';               				
		$.getJSON(jsonp_url, function(data) {			
        	$('#ggs_display_widget').html(data);
        });				
    });
}
})();
