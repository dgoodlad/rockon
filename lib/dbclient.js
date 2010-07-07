var couchdb = require('couchdb');

exports.connect = function(host, port, dbname) {
  var client = couchdb.createClient(5984, 'localhost');
  return client.db('rockon');
};

