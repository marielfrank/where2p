$(function() {
    listRatings();
    showRatingForm();
    postRating();
});

function Rating (attr) {
    this.id = attr.id;
    this.stars = attr.stars;
    this.comment = attr.comment;
    this.userName = attr.user['name'];
};

Rating.prototype.renderNewRating = function() {
    return Rating.renderRating(this)
}

function setupHandleBars() {
    Rating.template = $('#rating-partial').html();
    Rating.renderRating = Handlebars.compile(Rating.template);
}

function listRatings() {
    $("#js-view-ratings").on("click", function(e) {
        setupHandleBars();
        $('#js-ratings').html("")
        let id = $(this).data("id");
        $.get(`/restrooms/${id}/ratings.json`, function(data) {
            $('#js-ratings').append('<br>')
            data.forEach(rating => {
                let rat = new Rating(rating);
                let ratDiv = rat.renderNewRating()
                $('#js-ratings').append(ratDiv);
            });
        });
        $('a#js-view-ratings').hide();
        e.preventDefault();
    });
}

function postRating() {
    $('form#new_rating').submit(function(e) {
        setupHandleBars();
        let url = this.action
        let formData = $(this).serialize();
        $.post(url, formData, function(ratingData) {
            let rat = new Rating(ratingData);
            let ratDiv = rat.renderNewRating()
            $('#js-ratings').append(ratDiv);
        }, "json");
        $('form#new_rating').trigger("reset");
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