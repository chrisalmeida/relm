const http   = require('http'),
      fs     = require('fs'),
      Elm    = require('./elm-server'),         // compiled Server.elm
      jsFile = fs.readFileSync('./elm-app.js'), // compiled Main.elm (client side)
      app    = Elm.Server.worker()

function headersToElm(headers) {
    headers = headers || function() {}
    return { host: headers.host || ''
    , connection: headers.connection || '' 
    , cacheControl: headers.cacheControl || ''
    , upgradeSecureRequests: headers.upgradeSecureRequests || ''
    , userAgent: headers.userAgent || ''
    , accept: headers.accept || ''
    , acceptEncoding: headers.acceptEncoding || ''
    , acceptLanguage: headers.acceptLanguage || ''
    , cookie: headers.cookie || ''
    }
}

function startServer(template, port) {
  http.createServer((req, res) => {
    switch (req.url) {
      case "/elm-app.js" :
        res.writeHead(200, {"Content-Type": "text/javascript"})
        res.write(jsFile);
        break;
      default :    
        const headers = headersToElm(req.headers)
        const r       = {url: req.url || '', headers: headers}
        app.ports.receivedRequest.send(r) // send request into elm
        res.writeHead(200, {"Content-Type": "text/html"})
        res.write(template) 
    }
    res.end() 
  }).listen(port)
}

app.ports.startServer.subscribe(function(elmArgs) {
  const port     = elmArgs.portNumber
  const template = elmArgs.template
  console.log('Starting server on port: ', port)
  startServer(template, port)
})
