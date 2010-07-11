Connect: require 'connect'

HOME: process.env['HOME']

Server: Connect.createServer(
  Connect.logger(),
  Connect.errorHandler({ showStack: true }),
)

main: (app) ->
  app.get '/', (req, res) ->
    body: '''
          <!DOCTYPE html>
          <html>
            <head>
              <title>Rock On!</title>
            </head>
            <body>
              <audio src="/music/Skream/Dubfiles Dubstep Documentary/08 Summer Dreams.mp3" controls autobuf>
            </body>
          </html>
          '''
    res.writeHead 200, {
      'Content-Type': 'text/html',
      'Content-Length': body.length
    }
    res.end body, 'utf8'

Server.use '/', Connect.router(main)
Server.use '/music', Connect.staticProvider("$HOME/.rockon/music")

module.exports: Server

