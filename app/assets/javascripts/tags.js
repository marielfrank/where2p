$(function() {
    listTags();
});
function listTags() {
    $('.add-tags form').submit(function(e) {
        e.preventDefault();
        let url = this.action
        let formData = $(this).serialize();
        console.log(formData);
        $.ajax({
            type: "PATCH",
            url: url,
            data: formData,
            success: function (response) {
                debugger;
            }
        });
    });
};