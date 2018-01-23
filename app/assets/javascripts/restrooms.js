$(function() {
    previewRestroom();
});

function previewRestroom() {
    $(".js-prev").on("click", function() {
        let id = $(this).data("id");
        $(".preview-rest").hide();
        $("#preview-rest-" + id).show();
        $.get("/restrooms/" + id + ".json", function(data) {
            $('#preview-address-' + id).html(`<strong>Address:</strong> ${data['address']} in ${data['neighborhood']['name']}`);
            let tags = data['tags'].map(tag => `${tag['description']}`).join("<br>");
            $('#preview-tags-' + id).html("<strong>Tags:</strong><br>" + tags);
        });
    });
}