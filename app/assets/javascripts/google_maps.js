// fire functions after turbolinks has loaded
$(document).on('turbolinks:load', function () {
    getCurrentUser();
    getUserLocation();
    shareLocation();
    getRestroomsLocs();
    getDirections();
    collapseDirections();
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
    // set Distance Matrix origin from user's current latitude & longitude
    let origin = { lat: parseFloat(userData['current_lat']), lng: parseFloat(userData['current_lng']) };
    // instantiate Distance Matrix service
    let service = new google.maps.DistanceMatrixService;
    // set request data
    let requestData = {
        origins: [origin],
        // dests was set on turbolinks load through getRestroomLocs()
        destinations: dests,
        travelMode: 'WALKING',
        unitSystem: google.maps.UnitSystem.IMPERIAL
    };
    // send get request through API
    service.getDistanceMatrix(requestData, function(response, status) {
        if (status !== 'OK') {
            alert("We weren't able to locate restrooms near you. Error was: " + status);
        } else {
            // set each JS restroom object's distance and duration from user
            restrooms.forEach(function (restroom, idx, arr) {
                restroom.distance = response['rows'][0]['elements'][idx]['distance']['text'];
                restroom.duration = response['rows'][0]['elements'][idx]['duration']['text'];
                // save restroom data in Rails database
                saveRestroom(restroom);
            });
            // redirect to /restrooms/by-distance
            window.location.replace('/restrooms/by-distance');
        };
    });
};

// called when turbolinks load
function getRestroomsLocs() {
    // fire get request for restrooms json data
    $.get("/restrooms.json", function(data) {
        // create restroom objects & add to restrooms array
        data.forEach(rest => {
            restrooms.push(new Restroom(rest));
        });
        // add restroom addresses to dests array
        dests = data.map(rest => `${rest['address']}, NYC`);
    });
};

function saveRestroom(restroom) {
    // send patch request to update restroom
    $.ajax({
        method: "PATCH",
        url: `/restrooms/${restroom['id']}`,
        data: {restroom, authenticity_token: window._token},
        dataType: "json",
        // send requests one at a time so database doesn't get overloaded
        async: false
    });
};

function getDirections() {
    // listen for 'get directions' to be clicked
    $('.get-directions').click( function () {
        // reset all maps & directions panels
        $('.map').html("");
        $('.map').removeClass('highlight-map');
        $('.directions-panel').html("");
        // get restroom id from clicked button
        let id = Number(this.id);
        // find JS restroom object by id
        let restroom = findById(id);
        // fire function to get directions for restroom
        calculateAndDisplayRoute(restroom);
        $(".get-directions").show();
        $(`#${id}`).hide();
        $(`#collapse-${id}`).removeClass("hide");
    });
};

// find JS restroom object by id using #find
function findById(id) {
    return restrooms.find(function (restroom) {
        return restroom.id === id;
    });
};

function getUserLocation() {
    // get current user's id
    let userId = user.id;
    // send get request for current user's json data
    $.get(`/users/${userId}.json`, function (userData) {
        // reset JS user object with current position data
        user = new User({id: userId, current_lat: userData['current_lat'], current_lng: userData['current_lng']});
    });
};

function calculateAndDisplayRoute(restroom) {
    // instantiate Google Maps Directions service & display
    const directionsService = new google.maps.DirectionsService;
    const directionsDisplay = new google.maps.DirectionsRenderer;

    // set start and end points for directions request
    let start = { lat: parseFloat(user['current_lat']), lng: parseFloat(user['current_lng']) };
    let end = restroom['address'];

    // send Directions get request through Google's API
    directionsService.route({
      origin: start,
      destination: end,
      travelMode: 'WALKING'
    }, function(response, status) {
      if (status === 'OK') {
        // set the response for directionsDisplay
        directionsDisplay.setDirections(response);
        // use setPanel to display directions
        directionsDisplay.setPanel(document.getElementById(`right-panel-${restroom.id}`));

        // make current restroom's map div visible
        $(`#map-${restroom.id}`).addClass('highlight-map');
        // instantiate new map in div
        map = new google.maps.Map(document.getElementById(`map-${restroom.id}`), {
            center: {lat: 40.71427, lng: -74.00597},
            zoom: 10
        });
        // set directions to display on map
        directionsDisplay.setMap(map);

      } else {
        alert('Directions request failed due to ' + status);
      }
    });
}

function collapseDirections() {
    $(".collapse-directions").click(function () {
        let id = this.id.split("-")[1];
        $(`#map-${id}`).html('');
        $(`#right-panel-${id}`).html('');
        $(`#${id}`).show();
        $(`#collapse-${id}`).addClass("hide");
    })
}