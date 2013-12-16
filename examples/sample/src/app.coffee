express = require('express')
http = require('http')
path = require('path')
parser = require '../../../src/toolkit-parser'
simplyLog = require 'simply-log'
Validation = require '../../../src/validation/validation'

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)

app.configure () =>
  @logger = simplyLog.consoleLogger 'raml-toolkit'
  @logger.setLevel simplyLog.DEBUG

  parser.loadRaml "/Users/evangelinamartinezruizmoreno/github/raml-toolkit/examples/leagues/leagues.raml", @logger, (toolkitParser) =>
    console.log 'Raml file loaded'
    @resources = toolkitParser.getResources()

    app.get('/teams/:teamId', (req, res) =>
      resource = @resources[req.route.path]
      validation = new Validation req, resource
      if not validation.isValid()
        res.status('400')
      else
        res.send({ name: 'test' })
    )

    app.get('/teams', (req, res) =>
      resource = @resources[req.route.path]
      validation = new Validation req, resource
      if not validation.isValid()
        res.status('400')
      else
        res.send({ name: 'test' })
    )

    app.post('/teams', (req, res) =>
      resource = @resources[req.route.path]
      validation = new Validation req, resource
      if not validation.isValid()
        res.status('400')
      else
        res.status('201')
    )

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
