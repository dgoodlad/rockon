var sys  = require('sys');

var discovery = require('./lib/discovery'),
    dbclient  = require('./lib/dbclient');

var db = dbclient.connect('localhost', 5984, 'rockon');

var changes = db.changesStream();
changes.addListener('data', function(change) {
  sys.log(sys.inspect(change));
});

if(process.argv.length > 2) {
  var PORT = parseInt(process.argv[2]);
} else {
  var PORT = 3579;
}

var browseServer = function(host, port) {
  var id = host + ':' + port;
  var doc = {
    _id:  id,
    type: 'server',
    host: host,
    port: port
  };

  db.saveDoc(id, doc, function(err, ok) {
    if(err) {
      sys.log(sys.inspect(err));
    } else {
      sys.log("Found server at " + host + ":" + port);
    }
  });
};

discovery.advertise(PORT);
discovery.browse(browseServer);

