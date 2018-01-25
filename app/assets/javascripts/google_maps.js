$(function () {
    shareLocation();
});

function User (attr) {
    this.current_lat = attr.current_lat;
    this.current_lng = attr.current_lng;
};

let destinations = [];

function shareLocation() {
    $('button#share-location').click(function () {
        const id = $(this).data('id');
        navigator.geolocation.getCurrentPosition(function (pos) {
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
            let user = new User({current_lat: lat, current_lng: lng});
            $.ajax({
                method: "PATCH",
                url: `/users/${id}`,
                data: {user, authenticity_token: window._token},
                dataType: "json"
              }).done(function (userData) {
                  getClosestRestrooms(userData);
              });
        });
    });
};

function getClosestRestrooms(userData) {
    let origin = new google.maps.LatLng(userData['current_lat'], userData['current_lng']);
    debugger
    getRestroomsLocs();
    const service = new google.maps.DistanceMatrixService;
    service.getDistanceMatrix({
        origins: [origin],
        destinations: destinations,
        travelMode: 'WALKING'
    }, function(response, status) {
        console.log(response);
        console.log(status);
        if (status !== 'OK') {
            alert('Error was: ' + status);
        } else {
            alert('Success!')
        }
    });
}

function getRestroomsLocs() {
    $.get("/restrooms.json", function(data) {
        destinations = data.map(rest => rest['address']);
    });
}