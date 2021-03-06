# The `models` `helper` defines Mongoose schemas and creates and sets models
# on the `app` instance so that they are available throughout the application.
helper models: ->
    # Define the `Road` schema.
    Road = new mongoose.Schema
        road: String
        directions: [String]
        cameraCount: Number
    Road.index 'road'
    mongoose.model 'Road', Road
    app.RoadModel = mongoose.model 'Road'

    # Define the `Camera` schema.
    Camera = new mongoose.Schema
        name: String
        roadId: String
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
