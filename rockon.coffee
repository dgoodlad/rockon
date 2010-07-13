# Rock On! \m/
# (c) 2010 David Goodlad

# Make it so we can require .coffee files directly
require 'coffee-script'

# Node standard modules
sys: require 'sys'
p: (obj) -> sys.puts(sys.inspect(obj))

# Rock On
FileScanner: require('./lib/filescanner').FileScanner
FileHasher:  require('./lib/filehasher').FileHasher
id3: require './lib/id3'
DB: require('./lib/db').DB
db: new DB('localhost', 5984, 'rockon')

knownFiles: 'not available'
db.knownFiles (files) ->
  knownFiles: files

isKnown: (dir, file, callback) ->
  if knownFiles == 'not available'
    process.nextTick ->
      isKnown dir, file, callback
  else
    files: knownFiles[dir]
    callback(if files? then files.indexOf(file) != -1 else false)

HOME: process.env['HOME']
scanner: new FileScanner /\.mp3$/, "$HOME/.rockon/music"
hasher:  new FileHasher()
scanner.addListener 'foundFile', (dir, file, stats) ->
  path: "$dir/$file"
  isKnown dir, file, (known) ->
    if known
      sys.log "Already know about $path"
    else
      id3.getTags path, (tags) ->
        hasher.hash path, (hash) ->
          sys.log "Discovered: $file"
          db.addTrack path, stats, hash, tags
scanner.scan()

require('./lib/webserver').listen 3000
