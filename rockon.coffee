# Rock On! \m/
# (c) 2010 David Goodlad

# Make it so we can require .coffee files directly
require 'coffee-script'

# Node standard modules
sys: require 'sys'

# Rock On
FileScanner: require('./lib/filescanner').FileScanner
id3: require './lib/id3'
DB: require('./lib/db').DB
db: new DB('localhost', 5984, 'rockon')

HOME: process.env['HOME']
scanner: new FileScanner /\.mp3$/, "$HOME/.rockon/music"
scanner.addListener 'foundFile', (file) ->
  sys.log "Discovered: " + file
  id3.getTags file, (tags) ->
    db.addTrack file, null, tags
scanner.scan()

require('./lib/webserver').listen 3000
