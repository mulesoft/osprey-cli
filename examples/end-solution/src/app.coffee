express = require 'express'
http = require 'http'
path = require 'path'
apiKit = require '../../../dist/middleware/api-kit'

app = express()

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()

# APIKit Configuration
# app.use apiKit.middleware(__dirname + '/assets/raml/api.raml', app.routes)
# app.use '/api/console', express.static(__dirname + '/assets/console')
# app.get '/api', apiKit.ramlEndpoint(__dirname + '/assets/raml/api.raml')

apiKit.register app, __dirname

http.createServer(app).listen(3000)
