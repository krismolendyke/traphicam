# TODO: Move the body of this client -> code to a modular Cake built system so
# that I can just call something like client -> $ -> new trphcm() here, or
# something like that.  I'll have to include trphcm.min.js in the allScripts
# of the default layout.
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
