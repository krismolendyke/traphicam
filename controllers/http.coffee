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

    render 'roads'
