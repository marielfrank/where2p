$(function () {
    shareLocation();
    getRestroomsLocs();
    getCurrentUser();
    getUserLocation();
    getDirections();
});

let dests = [];
let restrooms = [];
let user = null;

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
        const id = $(this).data('id');
        navigator.geolocation.getCurrentPosition(function (pos) {
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
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
    return
}

// function initMapById(id) {
    // const directionsDisplay = new google.maps.DirectionsRenderer;
    // const directionsService = new google.maps.DirectionsService;
//     // let map = new google.maps.Map($(`#map-${id}`), {
//     //   zoom: 7,
//     //   center: {lat: 40.730610, lng: -73.935242}
//     // });
//     var directionsDisplay = new google.maps.DirectionsRenderer;
//     var directionsService = new google.maps.DirectionsService;
//     var map = new google.maps.Map(document.getElementById('map'), {
//         zoom: 7,
//         center: {lat: 41.85, lng: -87.65}
//     });

//     directionsDisplay.setMap(map);
//     // debugger
//     // directionsDisplay.setPanel($(`#right-panel-${id}`));

//     // const control = $('#floating-panel');
//     // control.style.display = 'block';
//     // map.controls[google.maps.ControlPosition.TOP_CENTER].push(control);

// }

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
      } else {
        alert('Directions request failed due to ' + status);
      }
    });
}
