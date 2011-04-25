var camBaseUrl, d5UrlProcessor, d6UrlProcessor, fs, handler, htmlparser, imageExtension, imagePrefix, pennDotHostName, sys, url, util, _, _s;
sys = require('sys');
fs = require('fs');
util = require('util');
_ = require('underscore');
_s = require('underscore.string');
url = require('url');
htmlparser = require('htmlparser');
pennDotHostName = 'www.dot.state.pa.us';
camBaseUrl = 'http://www.dot35.state.pa.us/public/Districts/District6/WebCams/';
imagePrefix = 'D6Cam';
imageExtension = ".jpg";
handler = new htmlparser.DefaultHandler(function(error, dom) {
  var anchor, anchors, camIds, index, _fn, _len;
  if (error) {
    util.debug(error);
  }
  anchors = htmlparser.DomUtils.getElementsByTagName('a', dom);
  camIds = [];
  _fn = function(anchor, index) {
    var u;
    u = url.parse(anchor.attribs.href);
    if (u.pathname.match(/.*district5.*/)) {
      camIds.push(d5UrlProcessor(u));
    }
    if (u.pathname.match(/.*district6.*TCamera.*/)) {
      return camIds.push(d6UrlProcessor(u));
    }
  };
  for (index = 0, _len = anchors.length; index < _len; index++) {
    anchor = anchors[index];
    _fn(anchor, index);
  }
  return console.log(camIds);
});
d5UrlProcessor = function(u) {
  return _(u.pathname.split('/')).last().substring(2);
};
d6UrlProcessor = function(u) {
  return _s.sprintf("" + imagePrefix + "%03d" + imageExtension, parseInt(_(u.pathname.split('/')).last().substring(7), 10));
};
fs.readFile('data/raw/District6WebcamsList.html', 'utf-8', function(err, contents) {
  var parser;
  parser = new htmlparser.Parser(handler);
  return parser.parseComplete(contents);
});
fs.readFile('data/raw/district5webcamslist.html', 'utf-8', function(err, contents) {
  var parser;
  parser = new htmlparser.Parser(handler);
  return parser.parseComplete(contents);
});