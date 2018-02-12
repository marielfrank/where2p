// fire functions after turbolinks has loaded
$(document).on('turbolinks:load', function() {
    listRatings();
    showRatingForm();
    postRating();
    viewBest();
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
    // debugger
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
            // create new JS rating object with response data
            let rat = new Rating(ratingData);
            // render newly created rating with Handlebars
            let ratDiv = rat.renderNewRating()
            // add rating to ratings div
            $('#js-ratings').append(ratDiv);
        // specify that request is for json format
        }, "json");
        $('form#new_rating').trigger("reset");
        // prevent form from submitting & redirecting the page
        e.preventDefault();
    });
};

function showRatingForm() {
    // when add rating link is clicked
    $("a#js-add-rating").click( function(e) {
        // show form
        $("div.hide").removeClass('hide');
        // hide 'add rating link'
        $('a#js-add-rating').hide();
        // prevent button from removing js elements from page
        e.preventDefault();
    });
};

function viewBest() {
    // look at the ratings.json for this restroom
    // filter for ratings with stars >= 3
    // display those ratings
    $('button.viewBest').click( function(e) {
        let id = $(this).data("id");
        // get Handlebars ready
        setupHandleBars();
        // reset div's contents
        $('#js-ratings').html("")
        // send get request for current restroom's json data
        $.get(`/restrooms/${id}/ratings.json`, function(data) {
            // push below any other contents
            $('#js-ratings').append('<br>');
            // debugger
            let bestRatings = data.filter( rating =>
                rating.stars >= 3
            )

            let sortedBest = bestRatings.sort(function (a, b) {
                return a.stars < b.stars
            })

            sortedBest.forEach(rating => {
                // debugger
                // create new JS rating object for each rating
                let rat = new Rating(rating);
                // send rating's data to Handlebars template
                // debugger
                let ratDiv = rat.renderNewRating();
                // add Handlebars rendered rating to ratings div
                $('#js-ratings').append(ratDiv);
                // $('#js-ratings').append(rat);
            });
        });
        // hide preview button
        // $('a#js-view-ratings').hide();
        e.preventDefault();
    })
}