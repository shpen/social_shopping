$(document).on("click", ".new-comment-button", function() {
	$(this).hide();
	$(this).parent().find('.new-comment-form').show();
	return false;
});