# The `models` `helper` defines Mongoose schemas and creates and sets models
# on the `app` instance so that they are available throughout the application.
helper models: ->
    # Define the `Camera` schema.
    Camera = new mongoose.Schema
        name: String
        url: String # TODO: make this a URL object sub-document.
        loc:
            x: Number
            y: Number

    # Geospatial indexing!
    Camera.index loc: '2d'

    # Create the `Camera` model.
    mongoose.model 'Camera', Camera

    # Set the `CameraModel` on the `app` instance so that it will be available
    # throughout the application.
    app.CameraModel = mongoose.model 'Camera'
