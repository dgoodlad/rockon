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

  foundFile: (dir, file, stats) ->
    this.emit 'foundFile', dir, file, stats if @pattern.test(file)

  scanDir: (dir) ->
    self: this
    fs.readdir dir, (err, files) ->
      return p(err) if err
      for file in files
        path: "$dir/$file"
        fs.stat path, (err, stats) ->
          return p(err) if err
          if stats.isFile()
            self.foundFile(dir, file, stats)
          else
            self.scanDir(path)

exports.FileScanner: FileScanner

