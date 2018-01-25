$(function () {
    shareLocation();
});

function shareLocation() {
    $('button#share-location').click(function () {
        navigator.geolocation.getCurrentPosition(function (pos) {
            debugger
            let lat = pos.coords.latitude;
            let lng = pos.coords.longitude;
        });
    });
};