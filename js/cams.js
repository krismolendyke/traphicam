(function() {
  var Cams;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Cams = (function() {
    Cams.prototype.baseUrl = 'http://164.156.16.43/public/Districts/District6/WebCams';
    Cams.prototype.toWork = [51, 50, 49, 48, 46, 45, 44, 71, 72, 73, 93, 94, 95, 96, 97, 98, 99, 100, 101, 174, 175, 176, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142];
    function Cams() {
      this.geoLocSuccess = __bind(this.geoLocSuccess, this);;
      this.watchSuccess = __bind(this.watchSuccess, this);;      this.home = new google.maps.LatLng(40.012638, -75.198691);
      this.work = new google.maps.LatLng(40.03734, -75.49763);
      this.spinner = $('img#spinner');
      this.camList = $('ul#cam-list');
      this.positionList = $('ul#position-list');
      if (navigator.geolocation) {
        this.spinner.show();
        navigator.geolocation.getCurrentPosition(this.geoLocSuccess);
      }
      $('ul#cam-list').delegate('li.cam-li', 'click', function(event) {
        var cam, headingText;
        headingText = $(event.currentTarget).find('.ui-li-heading').text();
        cam = $(event.currentTarget).find('img.cam').clone().removeClass();
        if ($.mobile.media('screen and (min-width: 350px)')) {
          cam.attr('width', 340);
        }
        return $('div#cam-detail').find('#cam-detail-heading').text(headingText).end().find('div[data-role="content"]').empty().append(cam);
      });
    }
    Cams.prototype.watchSuccess = function(position) {
      var difference, positionLatLng;
      positionLatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      if (this.lastPositionLatLng != null) {
        difference = google.maps.geometry.spherical.computeDistanceBetween(positionLatLng, this.lastPositionLatLng);
      }
      if (!(positionLatLng.equals(this.lastPositionLatLng) || position.coords.accuracy > difference)) {
        position.coords.date = new Date().toLocaleTimeString();
        position.coords.difference = difference || 0;
        this.lastPositionLatLng = positionLatLng;
        return this.positionList.append($('script#position-item').tmpl(position)).listview('refresh');
      }
    };
    Cams.prototype.geoLocSuccess = function(position) {
      var current, destination, fromHome, fromWork;
      this.spinner.hide();
      current = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      fromHome = google.maps.geometry.spherical.computeDistanceBetween(current, this.home);
      fromWork = google.maps.geometry.spherical.computeDistanceBetween(current, this.work);
      destination = fromHome < fromWork ? 'work' : 'home';
      $('div#distances').html("<strong>" + (fromHome.toFixed(0)) + "</strong>m from home, \n<strong>" + (fromWork.toFixed(0)) + "</strong>m from work.");
      $('span#destination').text("to " + destination);
      return this.loadThumbs(destination);
    };
    Cams.prototype.geoLocError = function(error) {
      return console.log('shit');
    };
    Cams.prototype.loadThumbs = function(destination) {
      var camNumbers, date, number, _i, _len, _results;
      if (destination == null) {
        destination = 'work';
      }
      camNumbers = this.toWork.slice(0);
      if (destination === 'work') {
        camNumbers.reverse();
      }
      this.camList.empty();
      date = new Date();
      _results = [];
      for (_i = 0, _len = camNumbers.length; _i < _len; _i++) {
        number = camNumbers[_i];
        _results.push(__bind(function(number) {
          var camItem, data;
          data = {
            number: number,
            url: this.getCamUrl(number),
            date: date
          };
          camItem = $('script#cam-item').tmpl(data);
          return this.camList.append(camItem).listview('refresh');
        }, this)(number));
      }
      return _results;
    };
    Cams.prototype.load = function(destination) {
      var camNumbers, number, _i, _len, _results;
      if (destination == null) {
        destination = 'work';
      }
      camNumbers = this.toWork.slice(0);
      if (destination === 'work') {
        camNumbers.reverse();
      }
      this.camList.empty();
      _results = [];
      for (_i = 0, _len = camNumbers.length; _i < _len; _i++) {
        number = camNumbers[_i];
        _results.push(__bind(function(number) {
          return this.camList.append($('<li>').addClass("ui-li ui-li-static ui-body-c").append($('<img>').attr('width', 290).attr('src', this.getCamUrl(number))));
        }, this)(number));
      }
      return _results;
    };
    Cams.prototype.getCamUrl = function(number) {
      if (number < 10) {
        number = "00" + number;
      } else if (number < 100) {
        number = "0" + number;
      }
      return "" + this.baseUrl + "/D6Cam" + number + ".jpg";
    };
    return Cams;
  })();
  $(function() {
    return new Cams();
  });
}).call(this);
