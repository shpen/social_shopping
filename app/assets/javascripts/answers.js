// Submit form
$(document).on("click", "#submit-button", function() {
    if (!checkLogin(true)) { return false; }

    $(this).hide();
    $("#new-answer-form").show();
    return false;
});

$(document).on("click", "#new-answer-form #cancel-button", function() {
    $("#new-answer-form").hide();
    $("#submit-button").show();
    return false;
});

// Edit form
$(document).on("click", ".answer-edit-button", function() {
    $(this).closest(".answer").hide();
    $(this).closest(".answer-main").find(".edit-form").show();
    return false;
});

$(document).on("click", ".answer-edit-cancel-button", function() {
    $(this).closest(".edit-form").hide();
    $(this).closest(".answer-main").find(".answer").show();
    return false;
});

$(document).on("click", ".answer-submit-button", function() {
    showLoadingOverlay(this);
});

$(document).on('confirm:complete', ".edit-form .delete", function(e, response) {
    if (response) {
        showLoadingOverlay(this);
    }
});