Connect: require 'connect'

HOME: process.env['HOME']

Server: Connect.createServer(
  Connect.logger(),
  Connect.errorHandler({ showStack: true }),
)

public: "$__dirname/../public"

Server.use '/',
  Connect.compiler({ src: public, enable: [ 'less' ] }),
  Connect.staticProvider(public)

Server.use '/music', Connect.staticProvider("$HOME/.rockon/music")

module.exports: Server

