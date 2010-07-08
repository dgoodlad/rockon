couchdb: require 'couchdb'

class DB
  constructor: (host, port, dbname) ->
    @couchdbclient: couchdb.createClient port, host
    @db: @couchdbclient.db dbname

  addTrack: (path, digest, metadata) ->
    @db.saveDoc {
      type: 'track',
      path: path,
      digest: digest,
      metadata: metadata || {}
    }

exports.DB: DB
