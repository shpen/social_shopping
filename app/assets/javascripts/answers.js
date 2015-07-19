$(document).on("click", "#submit-button", function() {
	$(this).hide();
	$("#new-answer-form").show();
	return false;
});

$(document).on("click", "#new-answer-form #cancel-button", function() {
  $("#new-answer-form").hide();
  $("#submit-button").show();
  return false;
});