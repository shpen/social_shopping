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
	var loggedIn = $("#logged-in").length > 0;

	if (!loggedIn && renderOverlay) {
		showLoginOverlay()
	}

	return loggedIn;
}

function showLoginOverlay() {
	$("#login-overlay").modal('show');
}

$(document).on("click", "#login-button", function() {
	showLoginOverlay();
	return false;
});