# Rock On! \m/
# (c) 2010 David Goodlad

# Make it so we can require .coffee files directly
require 'coffee-script'

# Node standard modules
sys: require 'sys'

# Rock On
FileScanner: require('./lib/filescanner').FileScanner
FileHasher:  require('./lib/filehasher').FileHasher
id3: require './lib/id3'
DB: require('./lib/db').DB
db: new DB('localhost', 5984, 'rockon')

HOME: process.env['HOME']
scanner: new FileScanner /\.mp3$/, "$HOME/.rockon/music"
hasher:  new FileHasher()
scanner.addListener 'foundFile', (file) ->
  id3.getTags file, (tags) ->
    hasher.hash file, (hash) ->
      sys.log "Discovered: " + file
      db.addTrack file, hash, tags
scanner.scan()

require('./lib/webserver').listen 3000
