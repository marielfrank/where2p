// fire functions after turbolinks has loaded
$(document).on('turbolinks:load', function() {
    listRatings();
    showRatingForm();
    postRating();
});

// rating object function
function Rating (attr) {
    this.id = attr.id;
    this.stars = attr.stars;
    this.comment = attr.comment;
    this.userName = attr.user['name'];
};

// render newly created rating for JS rating object using Handlebars template
Rating.prototype.renderNewRating = function() {
    return Rating.renderRating(this)
}

// get Handlebars ready
function setupHandleBars() {
    // get template from page
    Rating.template = $('#rating-partial').html();
    // compile tempate
    Rating.renderRating = Handlebars.compile(Rating.template);
}

function listRatings() {
    // listen for "view ratings" button to be clicked
    $("#js-view-ratings").on("click", function(e) {
        // get Handlebars ready
        setupHandleBars();
        // reset div's contents
        $('#js-ratings').html("")
        // get current restroom's id from data attributes
        let id = $(this).data("id");
        // send get request for current restroom's json data
        $.get(`/restrooms/${id}/ratings.json`, function(data) {
            // push below any other contents
            $('#js-ratings').append('<br>');
            data.forEach(rating => {
                // create new JS rating object for each rating
                let rat = new Rating(rating);
                // send rating's data to Handlebars template
                let ratDiv = rat.renderNewRating();
                // add Handlebars rendered rating to ratings div
                $('#js-ratings').append(ratDiv);
            });
        });
        // hide preview button
        $('a#js-view-ratings').hide();
        e.preventDefault();
    });
}

function postRating() {
    // listen for new rating form to be submitted
    $('form#new_rating').submit(function(e) {
        // get Handlebars ready
        setupHandleBars();
        // get url from form
        let url = this.action
        // serialize form data into a string
        let formData = $(this).serialize();
        // send post request to /ratings with form data
        $.post(url, formData, function(ratingData) {
            // 
            let rat = new Rating(ratingData);
            let ratDiv = rat.renderNewRating()
            $('#js-ratings').append(ratDiv);
        // specify that request is for json format
        }, "json");
        $('form#new_rating').trigger("reset");
        // prevent form from submitting & redirecting the page
        e.preventDefault();
    });
};

function showRatingForm() {
    $("a#js-add-rating").click( function(e) {
        $("div.hide").removeClass('hide');
        $('a#js-add-rating').hide();
        e.preventDefault();
    });
};