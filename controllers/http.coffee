# Root is a simple list of various ways to look at cameras.
get '/': -> render 'default'

# Get a list of nearby cameras based on the user's position, if they choose to
# share it.
get '/nearby': ->
    # See `models.coffee`
    models()

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    render 'nearby'

# Get a list of cameras by road that they are on.
get '/roads': ->
    # See `models.coffee`
    models()

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    app.RoadModel.find().sort(['cameraCount'], -1).run (err, roads) =>
        console.log err if err?
        @roads = JSON.stringify roads
        render 'roads'

get '/roads/:roadId/:direction': ->
    models()
    mongoose.connect 'mongodb://localhost/cams'

    switch @direction
        when 'north'
            sortComponent = 'loc.y'
            sortOrder = 1
        when 'south'
            sortComponent = 'loc.y'
            sortOrder = -1
        when 'west'
            sortComponent = 'loc.x'
            sortOrder = -1
        when 'east'
            sortComponent = 'loc.x'
            sortOrder = 1

    app.CameraModel.find(roadId: @roadId).sort([sortComponent], sortOrder)
        .run (err, @cameras) =>
            render 'road'
