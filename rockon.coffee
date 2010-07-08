# Rock On! \m/
# (c) 2010 David Goodlad

# Make it so we can require .coffee files directly
require 'coffee-script'

# Node standard modules
sys: require 'sys'

# Rock On
filescanner: require './lib/filescanner'
id3: require './lib/id3'

HOME: process.env['HOME']
scanner: filescanner.createScanner "$HOME/.rockon/music"
scanner.scan (path, digest) ->
  sys.log "Discovered: " + path
  sys.log "            " + digest
  id3.getTags path, (tags) ->
    sys.log sys.inspect(tags)
