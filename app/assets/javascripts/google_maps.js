$(function () {
    shareLocation();
});

function User (attr) {
    this.id = attr.id;
    this.current_location = attr.current_location;
};

function shareLocation() {
    $('button#share-location').click(function () {
        navigator.geolocation.getCurrentPosition(function (pos) {
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
            debugger
        });
    });
};