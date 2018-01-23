$(function() {
    Rating.template = $('#rating-partial').html();
    Rating.renderRating = Handlebars.compile(Rating.template);
    listRatings();
    showRatingForm();
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

function listRatings() {
    $("#js-view-ratings").on("click", function(e) {
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

// function postRating() {
//     $('.add-rating form').submit(function(e) {
//         e.preventDefault();
//         let url = this.action
//         let formData = $(this).serialize();
//         console.log(formData);
        
//     });
// };

function showRatingForm() {
    $("a#js-add-rating").click( function(e) {
        // const restId = $(this).data('id');

        e.preventDefault();
    });
};