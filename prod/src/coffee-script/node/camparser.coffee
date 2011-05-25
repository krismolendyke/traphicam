sys = require 'sys'
fs = require 'fs'
xml2js = require 'xml2js'
_ = require 'underscore'
URL = require 'url'
mongoose = require 'mongoose'

parser = new xml2js.Parser()

parser.addListener 'end', (result) ->
    # Define the mongoose schema
    Camera = new mongoose.Schema
        name: String
        url: String
        loc:
            x: Number
            y: Number
    Camera.index loc: '2d'

    # Create the mongoose model
    mongoose.model 'Camera', Camera
    CameraModel = mongoose.model 'Camera'

    # Connect to mongodb
    mongoose.connect 'mongodb://localhost/cams'

    # Remove all previously saved documents
    aCamera = new CameraModel()
    aCamera.collection.drop()

    # Parse each Placemark into a mongoose model and save each
    _(result.Document.Folder.Placemark).each (placemark, i) ->
        url = URL.parse placemark.description.split('"')[3]
        coords = placemark.Point.coordinates.split ','

        aCamera = new CameraModel
            name: placemark.name
            url: url.href
            loc:
                x: parseFloat coords[0], 10
                y: parseFloat coords[1], 10

        aCamera.save (err) ->
            if err then console.log """Could not save camera #{i}:

#{aCamera}

Error: #{err}"""

    console.log "If you haven't seen any errors, we've probably been successful."

fs.readFile 'data/raw/trafficcameraswithfeed.kml', (err, data) ->
    parser.parseString data
