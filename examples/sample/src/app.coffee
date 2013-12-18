express = require('express')
http = require('http')
path = require('path')
parser = require '../../../src/toolkit-parser'
simplyLog = require 'simply-log'
Validation = require '../../../src/validation/validation'
utils = require 'express/lib/utils'

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())

class UriTemplateReader
  constructor: (@templates) ->
    for template in @templates
      do (template) ->
        regexp = utils.pathRegexp template.uriTemplate, [], false, false
        template.regexp = regexp

  getTemplateFor: (uri) ->
    template = @templates.filter (template) ->
      uri.match(template.regexp)?.length

    if template? and template.length then template[0] else null

  getUriParametersFor: (uri) ->
    template = @getTemplateFor uri
    return null unless template?
    matches = uri.match template.regexp
    keys = template.uriTemplate.match template.regexp
    uriParameters = {}
    for i in [1..(keys.length - 1)]
      uriParameters[keys[i].replace ':', ''] = matches[i]
    uriParameters

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

        templates = toolkitParser.getUriTemplates()

        uriTemplateReader = new UriTemplateReader templates

        validation = new Validation req, uriTemplateReader, resource

        if not validation.isValid()
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



