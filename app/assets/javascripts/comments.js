$(document).on("click", ".new-comment-button", function() {
    if (!checkLogin(true)) { return false; }

	$(this).hide();
	$(this).parent().find('.new-comment-form').show();
	return false;
});