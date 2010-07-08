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

filesToHash: []
hashing: false

hashFiles: () ->
  hashing: true
  path: filesToHash.pop()
  hash: crypto.createHash 'md5'
  stream: fs.createReadStream path
  stream.addListener 'data', (data) ->
    hash.update data
  stream.addListener 'end', () ->
    sys.log "Discovered: " + path
    sys.log "            " + hash.digest('hex')
    if filesToHash.length == 0
      hashing: false
    else
      hashFiles()

queueFile: (file) ->
  filesToHash.push file
  hashFiles() unless hashing

scanDir "/Volumes/Ninja/iTunes", queueFile

