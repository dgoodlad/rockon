sys:    require 'sys'
fs:     require 'fs'
crypto: require 'crypto'
EventEmitter: require('events').EventEmitter

p: (obj) -> sys.debug(sys.inspect(obj))

class FileHasher
  constructor: (algorithm) ->
    @algorithm: algorithm || 'sha1'
    @running: false
    @files: []

  hash: (file, callback) ->
    @files.push [file, callback]
    this.run() unless @running

  run: ->
    if !@running && @files.length > 0
      @running: true
      this.processNext()

  getNext: ->
    @files.shift() || []

  processNext: ->
    [file, callback]: this.getNext()
    if file?
      this.process file, callback
    else
      @running: false

  process: (file, callback) ->
    hash: crypto.createHash @algorithm
    stream: fs.createReadStream file
    bytes: 0
    stream.addListener 'data', (data) ->
      hash.update data.toString('binary', 0, data.length)
    stream.addListener 'end', () =>
      callback hash.digest('hex')
      this.processNext()

exports.FileHasher: FileHasher

