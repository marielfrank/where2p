// fire functions after turbolinks has loaded
$(document).on('turbolinks:load', function() {
    previewRestroom();
});

function previewRestroom() {
    // listen for preview button to be clicked
    $(".js-prev").on("click", function() {
        // get id from button data attributes
        let id = $(this).data("id");
        // show any hidden preview buttons
        $(".js-prev").show();
        // hide current preview button
        $(this).hide();
        // hide any visible preview divs
        $(".preview-rest").hide();
        // show current preview div
        $("#preview-rest-" + id).show().addClass('preview-rest-style');
        // send get request for current restroom's json data
        $.get("/restrooms/" + id + ".json", function(data) {
            // set restroom data in preview div
            $('#preview-address-' + id).html(`<strong>Address:</strong> ${data['address']} in ${data['neighborhood']['name']}`);
            let tags = data['tags'].map(tag => `${tag['description']}`).join("<br>");
            $('#preview-tags-' + id).html("<strong>Tags:</strong><br>" + tags);
        });
    });
}