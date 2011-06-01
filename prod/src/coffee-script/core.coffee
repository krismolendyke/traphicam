class trphcm
    constructor: ->
        @socket = new io.Socket()

        @socket.on 'connect', ->
            $('div[data-role="content"]').append $('<p>').text 'Connected'

        @socket.on 'disconnect', ->
            $('div[data-role="content"]').append $('<p>').text 'Disconnected'

        @socket.on 'message', (raw) =>
            msg = JSON.parse raw
            console.log msg

            # A message from the server.
            if msg.message
                $('div[data-role="content"]')
                    .append $('<p>').text "#{msg.message.text}"

            # A result from the server based on current position.
            if msg.currentPosition then @load msg

        @socket.connect()

        $('a#refresh').click =>
            $('ul#cam-list').empty()
            @sendCurrentPosition()

        if navigator.geolocation then @sendCurrentPosition()
        else
            @socket.send JSON.stringify error:
                message: 'Geolocation unsupported.'

    load: (msg) =>
        # Show sensible units for accuracy.  Feet if under a half mile, miles
        # if over.
        if msg.currentPosition.position.coords.accuracy > 2640
            accuracy = "#{(parseFloat(msg.currentPosition.position.coords.accuracy, 10) / 5280).toFixed 2} miles"
        else
            accuracy = "#{msg.currentPosition.position.coords.accuracy} feet"

        # When the current position was taken, as a `Date`
        currentPositionDate = new Date msg.currentPosition.position.timestamp

        # The time the current position was taken, as a `String` to display
        # near each camera image.
        currentPositionTimeString = currentPositionDate.toLocaleTimeString()

        $('p#stats').empty().text """It looks like you're at
(#{msg.currentPosition.position.coords.latitude}, #{msg.currentPosition.position.coords.longitude}), within an accuracy of #{accuracy} and that there's at least #{msg.currentPosition.cameras.results.length} cameras within a distance of #{msg.currentPosition.cameras.maxDistance} miles at #{currentPositionDate}."""

        for camera in msg.currentPosition.cameras.results
            # TODO: Do this img anti-cache server-side with node's URL API.
            if camera.obj.url.indexOf '?' is -1
                queryString = "?t=#{Date.now()}"
            else
                queryString = "&t=#{Date.now()}"
            camera.obj.url = "#{camera.obj.url}#{queryString}"

            # Inject the time string so it can be displayed near the image.
            camera.time = currentPositionTimeString

            $('ul#cam-list').append($('script#cam-item').tmpl(camera))
        $('ul#cam-list').listview 'refresh'

    sendCurrentPosition: =>
        navigator.geolocation.getCurrentPosition (position) =>
            @socket.send JSON.stringify currentPosition:
                position: position
