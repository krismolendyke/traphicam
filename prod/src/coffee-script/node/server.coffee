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
    CameraModel = mongoose.model 'Camera'

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    # Count those cameras!
    CameraModel.count {}, (err, @count) =>
        # mongoose.disconnect()
        render 'default'

# Socket.io connections
at connection: ->
    send 'welcome', text: 'Hello!'

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
            if msg.welcome
                $('div[data-role="content"]')
                    .append $('<p>').text "#{msg.welcome.text}"
            if msg.currentPosition
                $('div[data-role="content"]')
                    .append $('<p>').text """It looks like you're at
(#{msg.currentPosition.position.coords.latitude}, #{msg.currentPosition.position.coords.longitude}), give or take #{msg.currentPosition.position.coords.accuracy} feet."""

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

msg currentPosition: ->
    send 'currentPosition', position: @position

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
                    @content
