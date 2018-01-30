$(function () {
    getCurrentUser();
    getUserLocation();
    shareLocation();
    getRestroomsLocs();
    getDirections();
});

let dests = [];
let restrooms = [];
let user = null;
let map = null;

function User (attr) {
    this.id = attr.id;
    this.current_lat = attr.current_lat;
    this.current_lng = attr.current_lng;
};

function Restroom(attr) {
    this.address = attr.address;
    this.id = attr.id;
    this.duration = attr.duration;
    this.distance = attr.distance;
}

function getCurrentUser() {
    let userId = $('#cu').data("cu");
    user = new User({id: userId});
    return user;
}

function shareLocation() {
    $('button#share-location').click(function () {
        navigator.geolocation.getCurrentPosition(function (pos) {
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
            let id = user.id
            user = new User({current_lat: lat, current_lng: lng});
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
    $.ajax({
        method: "PATCH",
        url: `/restrooms/${restroom['id']}`,
        data: {restroom, authenticity_token: window._token},
        dataType: "json",
        async: false
    });
};

function getDirections() {
    $('.get-directions').click( function () {
        $('.map').html("");
        $('.map').removeClass('highlight-map');
        $('.directions-panel').html("");
        let id = Number(this.id);
        let restroom = findById(id);
        calculateAndDisplayRoute(restroom);
    });
};

function findById(id) {
    return restrooms.find(function (restroom) {
        return restroom.id === id;
    });
};

function getUserLocation() {
    let userId = user.id;
    $.get(`/users/${userId}.json`, function (userData) {
        user = new User({id: userId, current_lat: userData['current_lat'], current_lng: userData['current_lng']});
    });
};

function initMap() {

}

function calculateAndDisplayRoute(restroom) {
    const directionsDisplay = new google.maps.DirectionsRenderer;
    const directionsService = new google.maps.DirectionsService;

    let start = { lat: parseFloat(user['current_lat']), lng: parseFloat(user['current_lng']) };
    let end = restroom['address'];

    directionsService.route({
      origin: start,
      destination: end,
      travelMode: 'WALKING'
    }, function(response, status) {
      if (status === 'OK') {
        directionsDisplay.setDirections(response);
        directionsDisplay.setPanel(document.getElementById(`right-panel-${restroom.id}`));

        $(`#map-${restroom.id}`).addClass('highlight-map');
        map = new google.maps.Map(document.getElementById(`map-${restroom.id}`), {
            center: {lat: 40.71427, lng: -74.00597},
            zoom: 10
        });
        directionsDisplay.setMap(map);

      } else {
        alert('Directions request failed due to ' + status);
      }
    });
}
