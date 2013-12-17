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

validations = (ramlPath) ->
  (req, res, next) ->
    @logger = simplyLog.consoleLogger 'raml-toolkit'
    @logger.setLevel simplyLog.DEBUG

    parser.loadRaml ramlPath, @logger, (toolkitParser) ->
      resources = toolkitParser.getResources()

      result = app.routes[req.method.toLowerCase()].filter (route) ->
        req.url.match(route.regexp)?.length

      if result.length
        resource = resources[result[0].path]

        validation = new Validation req, resource

        if not validation.isValid()
          console.log "llegue aca la puta que lo pario!!!"
          res.status('400')
          return

      next()

app.use validations("../leagues/leagues.raml")

app.get('/teams/:teamId', (req, res) =>
  res.send({ name: 'test' })
)

app.get('/teams', (req, res) =>
  res.send({ name: 'test' })
)

app.post('/teams', (req, res) =>
  res.status('201')
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
