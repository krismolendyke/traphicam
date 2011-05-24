sys = require 'sys'
fs = require 'fs'
xml2js = require 'xml2js'
_ = require 'underscore'

parser = new xml2js.Parser()

parser.addListener 'end', (result) ->
    cams = []
    _(result.Document.Folder.Placemark).each (placemark) ->
        coords = placemark.Point.coordinates.split ','
        url = placemark.description.split('"')[3]

        cams.push
            name: placemark.name
            url: url
            LatLng:
                lat: parseFloat coords[0], 10
                lng: parseFloat coords[1], 10

    console.log cams

fs.readFile 'data/raw/trafficcameraswithfeed.kml', (err, data) ->
    parser.parseString data
