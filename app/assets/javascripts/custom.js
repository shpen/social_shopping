// Change paginate buttons to be ajax
function ajaxifyPaginate() {
	$("ul.pagination li a").each(function() {
		if ($(this).attr("href") != "#") {
			$(this).attr("data-remote","true");
		}
	});
}

$(ajaxifyPaginate);

// Activate loading overlay for certain ajax actions
function showLoadingOverlay(rootElement) {
	$(rootElement).closest(".loading-container").prepend("<div class='loading-overlay'></div>");
}

// Make ajax clicks activate loading overlay
$(document).on("click", ".sort, ul.pagination li a", function() {
	if ($(this).attr("href") != "#") {
		showLoadingOverlay(this);
	}
});

// Check if user logged in, and render overlay if needed
function checkLogin(renderOverlay) {
	if (renderOverlay) {
		$("#login-overlay").show();
	}

	return $("#logged-in").length > 0;
}