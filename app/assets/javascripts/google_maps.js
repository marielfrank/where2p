$(function () {
    shareLocation();
    getRestroomsLocs();
});

function User (attr) {
    this.current_lat = attr.current_lat;
    this.current_lng = attr.current_lng;
};

function Restroom(attr) {
    this.address = attr.address;
    this.id = attr.id;
    this.duration = attr.duration;
    this.distance = attr.distance;
}

let dests = [];
let restrooms = [];

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
    let origin = { lat: parseFloat(userData['current_lat']), lng: parseFloat(userData['current_lng']) };
    let service = new google.maps.DistanceMatrixService;
    let requestData = {
        origins: [origin],
        destinations: dests,
        travelMode: 'WALKING',
        unitSystem: google.maps.UnitSystem.IMPERIAL
    };
    service.getDistanceMatrix(requestData, function(response, status) {
        if (status !== 'OK') {
            alert("We weren't able to locate restrooms near you. Error was: " + status);
        } else {
            restrooms.forEach(function (restroom, idx, arr) {
                restroom.distance = response['rows'][0]['elements'][idx]['distance']['text'];
                restroom.duration = response['rows'][0]['elements'][idx]['duration']['text'];
                saveRestroom(restroom);
            });
        
            window.location.replace('/restrooms/by-distance');
        };
    });
};

function getRestroomsLocs() {
    $.get("/restrooms.json", function(data) {
        data.forEach(rest => {
            restrooms.push(new Restroom(rest));
        });
        dests = data.map(rest => `${rest['address']}, NYC`);
    });
};

function saveRestroom(restroom) {
    // debugger
    $.ajax({
        method: "PATCH",
        url: `/restrooms/${restroom['id']}`,
        data: {restroom, authenticity_token: window._token},
        dataType: "json",
        async: false
    });
};