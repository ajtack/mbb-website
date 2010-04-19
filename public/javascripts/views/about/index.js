$(document).ready(function() {
	// Map the URLs to the javascript equivalents (since we have javascript)
	$('#AboutSections a').attr('href', function(_, previous) { return previous + '.js'});
	
	// Set up a tabbed selector.
	$('#AboutSections').tabs().addClass('ui-tabs-vertical ui-helper-clearfix').removeClass('ui-corner-all ui-widget-content');
	$('#AboutSections li').removeClass('ui-corner-top').addClass('ui-corner-left');
	$('#AboutSections #Content').removeClass('ui-tabs-panel').addClass('ui-widget-content ui-corner-all');
});
