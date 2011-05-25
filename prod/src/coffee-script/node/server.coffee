using 'util'

# Can't figure out how else to use project-local module with Zappa.
def mongoose: require "#{process.cwd()}/node_modules/mongoose"

get '/': ->
    # Define the mongoose schema.
    Camera = new mongoose.Schema
        name: String
        url: String
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
            if msg.message
                $('div[data-role="content"]')
                    .append $('<p>').text "#{msg.message.text}"
            if msg.currentPosition
                $('p#stats').text """It looks like you're at
(#{msg.currentPosition.position.coords.latitude}, #{msg.currentPosition.position.coords.longitude}), give or take #{msg.currentPosition.position.coords.accuracy} feet and that there's at least #{msg.currentPosition.cameras.length} cameras nearby."""

                for camera in msg.currentPosition.cameras
                    $('ul#cam-list').append($('script#cam-item').tmpl(camera))
                $('ul#cam-list').listview 'refresh'

        socket.connect()

        if navigator.geolocation
            navigator.geolocation.getCurrentPosition (position) ->
                socket.send JSON.stringify currentPosition:
                    position: position
        else
            socket.send JSON.stringify error:
                message: 'Geolocation unsupported.'

# Very simple error handling.
msg error: -> send 'error', @message

# Use the current position to do a geospatial lookup of available cameras.
msg currentPosition: ->
    pos = [@position.coords.latitude, @position.coords.longitude]
    console.log {loc: $near: pos, $maxDistance: .1}
    app.CameraModel.find {loc: $near: pos, $maxDistance: .1}, (err, docs) =>
        if err
            send 'message', text: JSON.stringify err
        else
            send 'currentPosition', position: @position, cameras: docs

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
                div 'data-role': 'header', ->
                    h1 'traPHIcam.com'
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
                            img class: 'ui-li-thumb', src: '${url}', alt: 'M.I.A.'
                            h3 class: 'ui-li-heading', '${name}'
