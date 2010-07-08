var sys  = require('sys'),
    mdns = require('mdns');

exports.advertise = function(port) {
  var ad = mdns.createAdvertisement('rockon', port, 'tcp');
  ad.start();
};

exports.browse = function(found) {
  var browser = mdns.createBrowser('rockon', 'tcp');
  browser.addListener('serviceUp', function(info) {
    found(info.hosttarget, info.port);
  });
  browser.start();
};
