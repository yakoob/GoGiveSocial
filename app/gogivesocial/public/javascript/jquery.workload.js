(function($) {

		$.fn.workload = function(options) {
		
		var defaults = {
		speed : 20, progress_max : 100
		}, 
		settings = $.extend({}, defaults, options);
			
			// For each loadbar instance
			return this.each(function() {
				
				// save instance in var
				var $workload = $(this);
				
				// save percentage amount in var and loose the '%' sign
				var percentage = parseInt($workload.children('.percentage').text());
								
				var amount = 0;
				var bar = 200;
				var counter = setInterval(function() {
					
					if (amount < percentage) {
							
						$workload.find('.load').animate({ 
							
							left: '-' + bar
							
						}, 10, function() {	
							
							$workload.children('.percentage').html(amount + '%');
							
							bar = bar - 2;	
							amount++;
							});
										
						} else {
							
							clearInterval(counter);
							$workload.children('.percentage').html(percentage + '%');
						
						}
					
						if (percentage > 100 ) {
							clearInterval(counter);
							$workload.children('.percentage').html(percentage + '%');
						}
					
					}, settings.speed);
				
			}); // end each
			
		}
		
})(jQuery)