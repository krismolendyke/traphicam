# Socket.io connections
at connection: ->

# Very simple error handling.
msg error: -> send 'error', @message

# Use the current position to do a geospatial lookup of available cameras.
msg currentPosition: ->
    pos = [@position.coords.latitude, @position.coords.longitude]

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
