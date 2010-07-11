sys: require 'sys'
fs:  require 'fs'
EventEmitter: require('events').EventEmitter

p: (obj) -> sys.debug(sys.inspect(obj))

class FileScanner extends EventEmitter
  constructor: (pattern, dirs...) ->
    @pattern: pattern
    @dirs: dirs
    super()

  scan: -> this.scanDir dir for dir in @dirs

  foundFile: (file) ->
    this.emit 'foundFile', file if @pattern.test(file)

  scanDir: (dir) ->
    self: this
    fs.readdir dir, (err, files) ->
      return p(err) if err
      for file in files
        path: "$dir/$file"
        fs.stat path, (err, stats) ->
          return p(err) if err
          if stats.isFile()
            self.foundFile(path)
          else
            self.scanDir(path)

exports.FileScanner: FileScanner

