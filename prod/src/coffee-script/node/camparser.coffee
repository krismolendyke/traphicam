# Parse traffic camera KML into MongoDB documents and save them with
# geospatial indexing.  This will allow for $near queries to return traffic
# cameras around a mobile device.

sys = require 'sys'
fs = require 'fs'
xml2js = require 'xml2js'
_ = require 'underscore'
URL = require 'url'
mongoose = require 'mongoose'
util = require 'util'

parser = new xml2js.Parser()

cameraToRoadMap = []

# Connect to mongodb.
mongoose.connect 'mongodb://localhost/cams'

# Read in the mapping of geocoded highway names.
fs.readFile 'data/roads.json', 'utf-8', (err, data) ->
    roads = JSON.parse data

    # Define the `Road` schema.
    Road = new mongoose.Schema
        name: String
        roadId: String
        directions: [String]
        cameraCount: Number

    Road.index 'road'
    mongoose.model 'Road', Road
    RoadModel = mongoose.model 'Road'
    aRoad = new RoadModel()
    aRoad.collection.drop()

    _(roads).each (road, i) ->
        if i + 1 is roads.length then isLast = true else isLast = false

        aRoad = new RoadModel
            name: road.road.name
            roadId: road.road.id
            directions: road.road.directions
            cameraCount: road.cameras.length

        aRoad.save (err) ->
            if err then console.log "Could not save road: #{aRoad}: #{err}"
            if isLast
                # Massage the data structure into a simple array for easy lookup of
                # road info. when the camera documents are created.
                for road in roads
                    for camera in road.cameras
                        cameraToRoadMap[camera] = road.road.name

                # Read and parse camera KML.
                fs.readFile 'data/raw/trafficcameraswithfeed.kml', (err, data) ->
                    if err then console.log err else parser.parseString data

# Parse camera KML into MongoDB.
parser.addListener 'end', (result) ->
    # Define the mongoose schema.
    Camera = new mongoose.Schema
        name: String
        url: String # TODO: Make this a URL object sub-document
        road: String
        loc:
            x: Number
            y: Number

    # Geospatial indexing!
    Camera.index loc: '2d'

    # Create the mongoose model.
    mongoose.model 'Camera', Camera
    CameraModel = mongoose.model 'Camera'

    # Remove all previously saved documents.
    aCamera = new CameraModel()
    aCamera.collection.drop()

    # Parse each Placemark into a mongoose model and save each.
    _(result.Document.Folder.Placemark).each (placemark, i) ->
        # Watch for the last camera since Model.save() is asynchronous and the
        # database connection should be closed after the last successful save.
        if i + 1 is result.Document.Folder.Placemark.length then isLast = true
        else isLast = false

        # Parse the camera URL out of the CDATA description soup.
        # TODO: Add some error handling around this, it's pretty brittle.
        url = URL.parse placemark.description.split('"')[3]

        # Coordinates are specified (lat, lng, alt) in the KML.  We only care
        # about two-dimenional coordinates.
        coords = placemark.Point.coordinates.split ','

        # Create a new camera!
        aCamera = new CameraModel
            name: placemark.name
            url: url.href
            road: cameraToRoadMap[placemark.name]
            loc:
                x: parseFloat coords[0], 10
                y: parseFloat coords[1], 10

        # Save the camera.  After the last camera is saved, close the
        # connection so that node isn't waiting around thinking more is
        # coming.
        aCamera.save (err) ->
            if err then console.log """Could not save camera #{i}:

#{aCamera}

Error: #{err}"""

            # Give some status and close the connection.
            if isLast
                CameraModel.count {}, (err, count) ->
                    console.log "Saved #{count} of #{result.Document.Folder.Placemark.length} cameras successfully."
                    mongoose.disconnect()
