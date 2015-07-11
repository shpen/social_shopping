/*
$(document).ready(function() {
	$('.sort').click(function() {
		// Toggle glyph icon
		var glyph = $(this).find('span.glyphicon');
		if (glyph.length > 0) {
			if(glyph.hasClass('glyphicon-sort-by-attributes')) {
				glyph.removeClass('glyphicon-sort-by-attributes');
				glyph.addClass('glyphicon-sort-by-attributes-alt');
			} else {
				glyph.removeClass('glyphicon-sort-by-attributes-alt');
				glyph.addClass('glyphicon-sort-by-attributes');
			}
		} else {
			$(this).append('<span class="glyphicon glyphicon-sort-by-attributes"></span>');
		}

		// Disable other sort
		var otherSort = $(this).parent().children().not(this);
		otherSort.removeClass('active');
		otherSort.find('span.glyphicon').remove();

		// Make selected sort active
		$(this).addClass('active');
	});
});
*/	

/*
$(document).ready(function() {
	$('.sort').click(function() {
		$(this).parent().parent().prepend("<div class='loading-overlay'></div>");
	});
});
*/

// Change paginate buttons to be ajax
function ajaxifyPaginate() {
	$("ul.pagination li a").each(function() {
		if ($(this).attr("href") != "#") {
			$(this).attr("data-remote","true");
		}
	});
}

$(ajaxifyPaginate);

// Make ajax clicks activate loading overlay
$(document).on("click", ".sort, ul.pagination li a", function() {
	if ($(this).attr("href") != "#") {
		$(this).parents(".loading-container").prepend("<div class='loading-overlay'></div>");
	}
});