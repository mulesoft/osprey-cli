express = require 'express'
http = require 'http'
path = require 'path'
parser = require '../../../dist/toolkit-parser'
utils = require 'express/lib/utils'

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

class ApiKitGetHandler
  resolve: (req, res, methodInfo) =>
    # TODO: Add validations
    # TODO: Add content negotiation
    res.contentType('application/json');
    res.send methodInfo.responses?['200']?.body?['application/json']?.example, { 'Content-Type': 'application/json' }, 200

class ApiKitPostHandler
  resolve: (req, res, methodInfo) =>
    # TODO: Add validations
    # TODO: Add content negotiation
    res.contentType('application/json');
    res.send 201

class ApiKitPutHandler
  resolve: (req, res, methodInfo) =>
    # TODO: Add validations
    res.send 204

class ApiKitDeleteHandler
  resolve: (req, res, methodInfo) =>
    # TODO: Add validations
    res.send 204

class ApiKitRouter
  constructor: (@routes, @resources, @uriTemplateReader) ->
    @httpMethodHandlers =
      get: new ApiKitGetHandler
      post: new ApiKitPostHandler
      put: new ApiKitPutHandler
      delete: new ApiKitDeleteHandler

  resolve: (req, res) =>
    template = @uriTemplateReader.getTemplateFor req.url
    method = req.method.toLowerCase()

    if template? and not @routerExists method, req.url
      console.log 'unless'
      methodInfo = @methodLookup method, template.uriTemplate

      if methodInfo?
        @httpMethodHandlers[method].resolve(req, res, methodInfo)

  methodLookup: (httpMethod, uri) =>
    if @resources[uri]?.methods?
      methodInfo = @resources[uri].methods.filter (method) ->
        method.method == httpMethod

    if methodInfo? and methodInfo.length then methodInfo[0] else null

  routerExists: (httpMethod, uri) =>
    if @routes[httpMethod]?
      result = @routes[httpMethod].filter (route) ->
        uri.match(route.regexp)?.length

    result? and result.length is 1

apiKit = (raml) ->
  (req, res, next) ->
    parser.loadRaml raml, (toolkitParser) ->
      resources = toolkitParser.getResources()
      templates = toolkitParser.getUriTemplates()
      uriTemplateReader = new UriTemplateReader templates

      router = new ApiKitRouter app.routes, resources, uriTemplateReader
      router.resolve req, res

      next()

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())

# Static Files Configuration
app.use(express.compress());
# TODO: Should I use max-cache?
app.use('/api/console', express.static(__dirname + '/assets/console'));
app.use('/api/raml', express.static(__dirname + '/assets/raml'));

app.use apiKit(__dirname + '/assets/raml/api.raml')

# app.get '/api', (req, res) ->
#   console.log req

# app.get('/teams', (req, res) ->
# 	res.send([{ name: 'All Teams' }])
# )

# app.get('/teams/:id', (req, res) ->
#   res.send({ name: 'by Id' })
# )

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
