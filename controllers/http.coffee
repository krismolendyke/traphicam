get '/': ->
    # `models()` is a `helper` which creates Mongoose schemas and models and
    # `sets the models on the `app` instance.  See models.coffee` for more
    # `information.
    models()

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    # Count those cameras!
    app.CameraModel.count {}, (err, @count) =>
        # mongoose.disconnect()
        render 'default'
