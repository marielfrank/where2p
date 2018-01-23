$(function() {
    listRatings();
});

class Rating {
    constructor (params) {
        this.id = params['id'];
        this.stars = params['stars'];
        this.comment = params['comment'];
        this.userName = params['user']['name'];
    }
};
function listRatings() {
    $("#js-view-ratings").on("click", function() {
        let id = $(this).data("id");
        $.get(`/restrooms/${id}/ratings.json`, function(data) {
            debugger
            let ratings = data.map(rating => `${rating['comment']}`).join("<br>");
            $('#js-ratings').html(ratings);
        });
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

function addRating() {
    
}