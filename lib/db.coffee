couchdb: require 'couchdb'

class DB
  constructor: (host, port, dbname) ->
    @couchdbclient: couchdb.createClient port, host
    @db: @couchdbclient.db dbname

  addTrack: (path, stats, digest, metadata) ->
    @db.saveDoc {
      _id: path,
      type: 'track',
      mtime: stats.mtime,
      digest: digest,
      metadata: metadata || {}
    }

  knownFiles: (callback) ->
    @db.view 'rockon', 'files', null, (err, json) ->
      files_by_path: {}
      json.rows.forEach (row) ->
        (files_by_path[row.key] ?= []).push(row.value)
      callback files_by_path

exports.DB: DB
