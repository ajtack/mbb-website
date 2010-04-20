$(document).ready(function() {
	// Map the URLs to the javascript equivalents (since we have javascript)
	$('#AboutSections a').attr('href', function(_, previous) { return previous + '.js'});
	
	// Set up a tabbed selector.
	$('#AboutSections').tabs();
});
