get '/': ->
    # See `models.coffee`
    models()

    # Connect to mongodb.
    mongoose.connect 'mongodb://localhost/cams'

    # Render the default view.
    render 'default'

    # This is sorta pointless right now.  The point is the render call is made
    # in the callback to the `count()` method since it's asynchronous.

    # Count those cameras!
    # app.CameraModel.count {}, (err, @count) =>
        # mongoose.disconnect()
        # render 'default'
