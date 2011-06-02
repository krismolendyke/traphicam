# Introduction

traphicam is a mobile traffic camera application for the Philadelphia region. PennDOT has installed hundreds of traffic cameras on our local major highways in the past several years but there has yet to be a well-designed, safe, mobile application which makes use of this valuable traffic data.

Ultimately, traphicam aspires to play a supporting in our daily transportation living decisions along side of radio, television and historically influenced traffic condition map applications.

Visit [traphicam.com](http://traphicam.com/ "traphicam.com") for a demonstration.

# Current Technology

traphicam consists of two main parts.  Both depend greatly on [node.js](http://nodejs.org/ "node.js") and [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript").

## Parsing, Inserting, & Indexing

The first part parses a [KML](http://en.wikipedia.org/wiki/Kml "Keyhole Markup Language - Wikipedia, the free encyclopedia") file containing [PennDOT](http://www.dot.state.pa.us/penndot/districts/district6.nsf/D6TrafficandMaps?OpenFrameSet "PennDOT District 6-0 Traffic &amp; Maps") traffic camera data and uses [Mongoose](http://mongoosejs.com/ "Mongoose ORM") to insert it into a [mongoDB](http://www.mongodb.org/ "MongoDB") database collection which is [geospatially indexed](http://www.mongodb.org/display/DOCS/Geospatial+Indexing "Geospatial Indexing - MongoDB").  With camera data in place and available to be queried by position coordinates `[latitude, longitude]`, we can turn to the second part of traphicam.

## The Web Application

The second part depends on [Zappa](https://github.com/mauricemach/zappa), a "[CoffeeScript](http://coffeescript.org) DSLish layer on top of [Express](http://expressjs.com), [Socket.IO](http://socket.io) and other libs".  The client-side code makes use of modern browsers' [Geolocation](https://developer.mozilla.org/en/Using_geolocation) [API](http://dev.w3.org/geo/api/spec-source.html "Geolocation API Specification") to query the server-side mongoDB camera collection for the nearest traffic camera data to the user's device.  A [geoNear](http://www.mongodb.org/display/DOCS/Geospatial+Indexing#GeospatialIndexing-geoNearCommand "Geospatial Indexing - MongoDB") command is used to return camera documents in nearest-order and obtain other useful information like how far each camera is from the query position. The [spherical model](http://www.mongodb.org/display/DOCS/Geospatial+Indexing#GeospatialIndexing-TheEarthisRoundbutMapsareFlat "Geospatial Indexing - MongoDB") introduced in mongoDB v1.7 is used.

Returned camera documents are rendered in the client browser using the [jQuery Mobile](http://jquerymobile.com/ "jQuery Mobile | jQuery Mobile") web framework.

# Future Goals

## More Data

traphicam is currently focused on the Philadelphia area.  At its core it is predicated upon a simple mapping of location to image information.  Expanding scope beyond the Philadelphia region should therefore be as easy as adding that information to the system.  Immediately, PennDOT has traffic cameras [across the state](http://www.dot.state.pa.us/Internet/Districts/DistrictGraphics.nsf/TrafficCamerasMap?OpenForm "PennDOT Traffic Cameras Map").

## Interface Improvements
  
Currently, the client-side interface makes a mostly boring use of jQuery Mobile features.  Since a major goal of this project is to not just present traffic camera data to mobile users, but to present it safely, much can be done yet.  Large, broad touch-gestures should be favored versus minute, distracting button pokes and endless scrolling.  

## Geolocation Improvements

Rather than have the user make requests to refresh both camera image data and location data, traphicam should make use of the Geolocation API `watchPosition` method and intelligently update nearest cameras and camera images.  This will require a lock-step design with an improved interface layout and gesturing support.

More intelligence regarding `heading`, whether it be absent or not from the `Coordinates`, combined with known route [directions](http://code.google.com/apis/maps/documentation/javascript/reference.html#DirectionsRequest "Google Maps Javascript API V3 Reference - Google Maps JavaScript API V3 - Google Code") could be used to present better upcoming camera results, or alternate routes.

mongoDB [bounds queries](http://www.mongodb.org/display/DOCS/Geospatial+Indexing#GeospatialIndexing-BoundsQueries "Geospatial Indexing - MongoDB") with custom polygons could be put to interesting use, as well.

## PhoneGap

A [PhoneGap](http://www.phonegap.com/ "PhoneGap") wrapper around jQuery Mobile could provide [higher accuracy geolocation](http://docs.phonegap.com/phonegap_geolocation_geolocation.md.html#Geolocation "PhoneGap API Documentation"), [Compass](http://docs.phonegap.com/phonegap_compass_compass.md.html "PhoneGap API Documentation") data, and support for geolocation where it might otherwise not be supported by certain devices.

The [Accelerometer API](http://docs.phonegap.com/phonegap_accelerometer_accelerometer.md.html "PhoneGap API Documentation") could possibly be used to aid in establishing safe-use of traphicam.  Audible [Notifications](http://docs.phonegap.com/phonegap_notification_notification.md.html "PhoneGap API Documentation") could be employed to alert the driver only when necessary.
