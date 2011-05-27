using 'util'

# Can't figure out how else to use project-local module with Zappa.
def mongoose: require "#{process.cwd()}/node_modules/mongoose"

def URL: require 'url'

# Used for spherical calculations.  According to WolframAlpha.
def radiusOfEarthMiles: 3956.6
def feetInAMile: 5280

get '/': ->
    # Define the mongoose schema.
    Camera = new mongoose.Schema
        name: String
        url: String # TODO: make this a URL object sub-document.
        loc:
            x: Number
            y: Number

    # Geospatial indexing!
    Camera.index loc: '2d'

    # Create the mongoose model.
    mongoose.model 'Camera', Camera
    app.CameraModel = mongoose.model 'Camera'
    # app.CameraModel = CameraModel

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    # Count those cameras!
    app.CameraModel.count {}, (err, @count) =>
        # mongoose.disconnect()
        render 'default'

# Socket.io connections
at connection: ->

# Default client-side code to include.
client ->
    # Wait for jQuery $(document).ready
    $ ->
        socket = new io.Socket()

        socket.on 'connect', ->
            $('div[data-role="content"]').append $('<p>').text 'Connected'

        socket.on 'disconnect', ->
            $('div[data-role="content"]').append $('<p>').text 'Disconnected'

        socket.on 'message', (raw) ->
            msg = JSON.parse raw
            console.log msg

            # A message from the server.
            if msg.message
                $('div[data-role="content"]')
                    .append $('<p>').text "#{msg.message.text}"

            # A result from the server based on current position.
            if msg.currentPosition then load msg

        load = (msg) ->
            # Show sensible units for accuracy.  Feet if under a half
            # mile, miles if over.
            if msg.currentPosition.position.coords.accuracy > 2640
                accuracy = "#{(parseFloat(msg.currentPosition.position.coords.accuracy, 10) / 5280).toFixed 2} miles"
            else
                accuracy = "#{msg.currentPosition.position.coords.accuracy} feet"

            $('p#stats').text """It looks like you're at
(#{msg.currentPosition.position.coords.latitude}, #{msg.currentPosition.position.coords.longitude}), within an accuracy of #{accuracy} and that there's at least #{msg.currentPosition.cameras.results.length} cameras within a distance of #{msg.currentPosition.cameras.maxDistance} miles at #{new Date(msg.currentPosition.position.timestamp)}."""

            for camera in msg.currentPosition.cameras.results
                # TODO: Do this server-side with node's URL API.
                if camera.obj.url.indexOf '?' is -1
                    queryString = "?t=#{Date.now()}"
                else
                    queryString = "&t=#{Date.now()}"
                camera.obj.url = "#{camera.obj.url}#{queryString}"

                $('ul#cam-list').append($('script#cam-item').tmpl(camera))
            $('ul#cam-list').listview 'refresh'


        socket.connect()

        $('a#refresh').click ->
            $('ul#cam-list').empty()
            sendCurrentPosition()

        sendCurrentPosition = ->
            navigator.geolocation.getCurrentPosition (position) ->
                socket.send JSON.stringify currentPosition:
                    position: position

        if navigator.geolocation then sendCurrentPosition()
        else
            socket.send JSON.stringify error:
                message: 'Geolocation unsupported.'

# Very simple error handling.
msg error: -> send 'error', @message

# Use the current position to do a geospatial lookup of available cameras.
msg currentPosition: ->
    pos = [@position.coords.latitude, @position.coords.longitude]

    # Old, dumb geospatial query.
    # query = loc: $near: pos, $maxDistance: .2
    # console.log query
    # app.CameraModel.find query, (err, docs) =>
    #     if err
    #         send 'message', text: JSON.stringify err
    #     else
    #         send 'currentPosition', position: @position, cameras: docs

    # For now, let's base the max distance on the accuracy of the location we
    # have.
    # maxDistance = parseFloat(@position.coords.accuracy, 10) / feetInAMile / radiusOfEarthMiles

    # Or, pick (user set?) a distance
    maxDistanceInMiles = 4
    maxDistanceInRadians = maxDistanceInMiles / radiusOfEarthMiles

    # Construct a new, hot geospatial query for nearest cameras.
    query =
        geoNear: 'cameras' # Collection name.
        near: pos
        distanceMultiplier: radiusOfEarthMiles # Get distances back in miles.
        spherical: true # We're dealing with the surface of the Earth!
        maxDistance: maxDistanceInRadians # Spherical requires radians.
        # num: 10 # Don't give back more than this, no matter what.

    console.log query
    mongoose.connection.db.executeDbCommand query, (err, docs) =>
        if err
            send 'message', text: JSON.stringify err
        else
            cameras = docs.documents[0]
            cameras.maxDistance = maxDistanceInMiles
            console.log cameras
            send 'currentPosition', position: @position, cameras: cameras

# Default view
view ->
    @scripts = [
         '/socket.io/socket.io'
        ,'http://code.jquery.com/jquery-1.6.1.min'
        ,'/default'
        ,'/js/jquery.tmpl.min'
        ,'/js/jquery.mobile-1.0a4.1.min'
    ]
    h1 "#{@count} cameras available"

# Simple HTML5 jQueryMobile layout
layout ->
    doctype 5
    html ->
        head ->
            meta charset: 'utf-8'
            title 'traPHIcam.com'
            meta
                name:'viewport'
                content: 'width=device-width, minimum-scale=1, maximum-scale=1'
            for s in @scripts
                script src: "#{s}.js"
            # Google's JavaScript loader is goofy and doesn't work with the
            # @scripts array I've setup so it must be specified here for now.
            script src:'http://maps.google.com/maps/api/js?libraries=geometry&sensor=true'
            link
                rel: 'stylesheet'
                href: '/css/jquery.mobile-1.0a4.1.min.css'
        body ->
            div 'data-role': 'page', ->
                div 'data-role': 'header', 'data-position': 'fixed', ->
                    h1 'traPHIcam.com'
                    a id: 'refresh', 'data-icon': 'refresh', -> 'Refresh'
                div 'data-role': 'content', ->
                    p id: 'stats'
                    ul
                        id: 'cam-list'
                        'data-role': 'listview'
                        class: 'ui-listview'
        # Camera list item jQueryMobile template.
        script id: 'cam-item', type: 'text/x-jquery-tmpl', ->
            li class: 'ui-li-has-thumb ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c cam-li', 'data-theme': 'c', ->
                div class: 'ui-btn-inner ui-li', ->
                    div class: 'ui-btn-text', ->
                        a class: 'ui-link-inherit', ->
                            img class: 'ui-li-thumb', src: '${obj.url}', alt: 'M.I.A.'
                            h3 class: 'ui-li-heading', '${obj.name}'
                            p class: 'ui-li-desc', '${dis.toFixed(2)} miles away'
