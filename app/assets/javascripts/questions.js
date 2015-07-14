$(document).on("click", "#question-edit-button", function() {
  $(".question").hide();
  $("#question-edit-form").show();
  return false;
});

$(document).on("click", "#question-edit-cancel-button", function() {
  $("#question-edit-form").hide();
  $(".question").show();
  return false;
});

$(document).on("click", "#question-submit-button", function() {
  showLoadingOverlay(this);
});