using 'util'

# Can't figure out how else to use project-local module with Zappa.
def mongoose: require "#{process.cwd()}/node_modules/mongoose"

def URL: require 'url'

# Used for spherical calculations.  According to WolframAlpha.
def radiusOfEarthMiles: 3956.6
def feetInAMile: 5280

# Models.
include 'models/default.coffee'

# Controllers. `controllers/client.coffee` has been deprecated in favor of
# `trphcm.js` which is built by `Cakefile` and is included from the default
# layout `layouts/default.coffee`.  See `prod/src/coffee-script`.
include 'controllers/http.coffee'
include 'controllers/websockets.coffee'

# Views.
include 'views/default.coffee'
include 'views/nearby.coffee'

# Layouts.
include 'layouts/default.coffee'
