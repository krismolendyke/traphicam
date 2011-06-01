get '/': ->
    # See `models.coffee`
    models()

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    # Count those cameras!
    app.CameraModel.count {}, (err, @count) =>
        # mongoose.disconnect()
        render 'default'
