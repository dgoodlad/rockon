require('express');
var fs = require('fs');

var sendfile = function(path, options, callback) {
  var self = this
  if (options instanceof Function)
    callback = options,
    options = {}
  else
    options = options || {}
  if (path.indexOf('..') !== -1)
    Error.raise('InvalidPathError', "`" + path + "' is not a valid path")
  fs.stat(path, function(err, stat){
    if (err)
      return 'errno' in err && err.errno === 2
        ? self.notFound()
        : self.error(err, callback)
    var etag = Number(stat.mtime)
    if (self.header('If-None-Match') && 
        self.header('If-None-Match') == etag)
      return self.respond(304, null)
    self.header('Content-Length', stat.size)
    self.header('ETag', etag)
    options.bufferSize = options.bufferSize
                      || 65536
    if (stat.size > options.bufferSize)
      return self.stream(fs.createReadStream(path, options))
    fs.readFile(path, function(err, content){
      if (err) return self.error(err, callback)
      self.contentType(path)
      self.respond(200, content)
    })
  })
  return this
}

get(/^\/music\/(.+\.mp3)$/, function(file) {
  var path = "/Users/dave/.rockon/music/" + file.replace(/%20/g, ' ');
  sendfile.apply(this, [path]);
  //return "Would get " + path;
});

var index = "<!DOCTYPE> \
<html> \
  <head> \
    <title>Rock On!</title> \
  </head> \
  <body> \
    <audio src='/music/Apocalyptica/Reflections/02 No Education.mp3' controls autobuffer> \
  </body> \
</html>";

get('/', function() {
  this.header('Content-Type', 'text/html');
  return index;
});

run();
