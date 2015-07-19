$(document).on("click", ".new-comment-button", function() {
	$(this).hide();

	var id = $(this).data('id');
	if (id === undefined) {
		$(".new-comment-form").show();
	} else {
		$('.new-comment-form[data-id="' + id + '"]').show();
	}

	return false;
});