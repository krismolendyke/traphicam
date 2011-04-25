sys = require 'sys'
fs = require 'fs'
util = require 'util'
_ = require 'underscore'
_s = require 'underscore.string'
url = require 'url'
htmlparser = require 'htmlparser'
# sizzle = require 'node-sizzle'
# dominiq = require 'node-sizzle/lib/dominiq'

pennDotHostName = 'www.dot.state.pa.us'

camBaseUrl = 'http://www.dot35.state.pa.us/public/Districts/District6/WebCams/'
imagePrefix = 'D6Cam'
imageExtension = ".jpg"

handler = new htmlparser.DefaultHandler (error, dom) ->
    util.debug error if error
    anchors = htmlparser.DomUtils.getElementsByTagName 'a', dom
    camIds = []
    
    for anchor, index in anchors then do (anchor, index) ->
        u = url.parse anchor.attribs.href
        if u.pathname.match /.*district5.*/
            camIds.push d5UrlProcessor u
        if u.pathname.match /.*district6.*TCamera.*/
            camIds.push d6UrlProcessor u
    console.log camIds

d5UrlProcessor = (u) -> 
    _(u.pathname.split '/').last().substring 2
    
d6UrlProcessor = (u) ->
    _s.sprintf "#{imagePrefix}%03d#{imageExtension}"
        , parseInt _(u.pathname.split '/').last().substring(7), 10

fs.readFile 'data/raw/District6WebcamsList.html', 'utf-8', (err, contents) ->
    parser = new htmlparser.Parser handler
    parser.parseComplete contents

fs.readFile 'data/raw/district5webcamslist.html', 'utf-8', (err, contents) ->
    parser = new htmlparser.Parser handler
    parser.parseComplete contents
