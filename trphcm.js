(function(window, undefined) {
var trphcm = function() {
    var CAMERA_LIST = $('#cameras');
    var REFRESH_BUTTON = $('#refresh');
    var HOST = 'http://localhost:1776';
    var NUM_CAMERAS = 10;

    var init = function() {
        REFRESH_BUTTON.on('vclick', refresh);

        REFRESH_BUTTON.hide();
        window.setTimeout(function() {
            REFRESH_BUTTON.show();
        }, 5000);
    };

    var refresh = function() {
        $.mobile.showPageLoadingMsg();
        REFRESH_BUTTON.hide();
        window.setTimeout(function() {
            REFRESH_BUTTON.show();
        }, 5000);

        $('li > img', CAMERA_LIST).each(function() {
            this.src = this.src.split('?')[0] + '?' + $.now();
        });

        $.mobile.hidePageLoadingMsg();
    };

    var getNearestCameras = function() {
        getCurrentPosition(function(position) {
            var url = HOST + '/' +
                    position.coords.latitude + '/' +
                    position.coords.longitude + '/' +
                    NUM_CAMERAS + '?callback=?';
            $.mobile.showPageLoadingMsg();
            $.getJSON(url, function(data) {
                console.log('data: ', data);
                var items = [];
                $.each(data, function() {
                    var item = $('<li>')
                    var image = $('<img>').attr({'src': this.url});
                    var description = $('<p>').text(this.name + ', ' +
                            this.miles_away + 'mi away');
                    item.append(image);
                    item.append(description);
                    items.push(item[0]);
                });
                CAMERA_LIST.append(items);
                CAMERA_LIST.listview('refresh');
                $.mobile.hidePageLoadingMsg();
            });
        });
    };

    var getCurrentPosition = function(f) {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(f);
        }
    };

    return {
        'init': init,
        'getNearestCameras': getNearestCameras,
        'refresh': refresh
    };
};

window.trphcm = new trphcm();

$('#index').live('pageinit', function(e) {
    window.trphcm.init();
    window.trphcm.getNearestCameras();
});
}(window))
