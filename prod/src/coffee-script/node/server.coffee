using 'util'

# Can't figure out how else to use project-local module with Zappa.
def mongoose: require "#{process.cwd()}/node_modules/mongoose"

def URL: require 'url'

# Used for spherical calculations.  According to WolframAlpha.
def radiusOfEarthMiles: 3956.6
def feetInAMile: 5280

# Models.
include 'models/default.coffee'

# Controllers.
include 'controllers/http.coffee'
include 'controllers/client.coffee'
include 'controllers/websockets.coffee'

# Views.
include 'views/default.coffee'

# Layouts.
include 'layouts/default.coffee'
