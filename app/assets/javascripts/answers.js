$(document).on("click", "#submit-button", function() {
	$(this).hide();
	$("#new-form").show();
	return false;
});

$(document).on("click", "#new-form #cancel-button", function() {
  $("#new-form").hide();
  $("#submit-button").show();
  return false;
});