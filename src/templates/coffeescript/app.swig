express = require 'express'
path = require 'path'
apiKit = require 'apikit-node'

app = module.exports = express()

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()
app.use express.logger('dev')

app.set 'port', process.env.PORT || 3000

apiKit.register '/{{apiPath}}', app, {
  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
  enableConsole: true,
  enableMocks: true
}

# Adding business logic to a valid RAML Resource
# apiKit.get '/examples/:exampleId', (req, res) ->
#   res.send({ name: 'example' })

unless module.parent
  port = app.get('port')
  app.listen port
  console.log "listening on port #{port}"