// fire functions after turbolinks has loaded
$(document).on('turbolinks:load', function () {
    getCurrentUser();
    getUserLocation();
    shareLocation();
    getRestroomsLocs();
    getDirections();
});

// set empty variables for later use
let dests = [];
let restrooms = [];
let user = null;
let map = null;

// user object function to keep track of current user's location
function User (attr) {
    this.id = attr.id;
    this.current_lat = attr.current_lat;
    this.current_lng = attr.current_lng;
};

// restroom object to keep track of restrooms in Distance Matrix 
// as related to Rails objects
function Restroom(attr) {
    this.id = attr.id;
    this.address = attr.address;
    this.duration = attr.duration;
    this.distance = attr.distance;
}

// get current user from layout div
function getCurrentUser() {
    let userId = $('#cu').data("cu");
    user = new User({id: userId});
    return user;
}

function shareLocation() {
    // listen for share-location button to be clicked
    $('button#share-location').click(function () {
        // get device's geolocation position
        navigator.geolocation.getCurrentPosition(function (pos) {
            // get latitude & longitude of position
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
            // get current user's id
            let id = user.id
            // create user object with latitude & longitude
            user = new User({current_lat: lat, current_lng: lng});
            // send patch request to current user's update path
            // get authenticity token from window
            $.ajax({
                method: "PATCH",
                url: `/users/${id}`,
                data: {user, authenticity_token: window._token},
                dataType: "json"
              }).done(function (userData) {
                  // after user has been updated, 
                  // get list of closest restrooms using response data
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
