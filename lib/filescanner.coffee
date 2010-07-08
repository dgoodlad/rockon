_:      require '../vendor/underscore'
sys:    require 'sys'
fs:     require 'fs'
crypto: require 'crypto'

p: (obj) -> sys.debug(sys.inspect(obj))

scanDir: (dirname, callback) ->
  fs.readdir dirname, (err, files) ->
    if err
      p err
    else
      for file in files
        path: "$dirname/$file"
        fs.stat path, (err, stats) ->
          if err
            p err
          else
            if stats.isFile()
              callback path
            else
              scanDir path, callback

files: []
hashing: false
hashFile: (file, callback) ->
  files.push { path: file, callback: callback }
  startHashing() unless hashing

startHashing: () ->
  hashing: true
  { path, callback } : files.pop()
  hash: crypto.createHash 'sha1'
  stream: fs.createReadStream path
  stream.addListener 'data', (data) ->
    hash.update data
  stream.addListener 'end', () ->
    callback path, hash.digest('hex')
    if files.length == 0
      hashing: false
    else
      startHashing()

exports.createScanner: (dir) ->
  {
    scan: (callback) ->
      scanDir dir, (file) ->
        callback file
        #fs.realpath file, (err, resolvedPath) ->
        #  callback resolvedPath
  }

