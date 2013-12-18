express = require 'express'
http = require 'http'
path = require 'path'
parser = require '../../../dist/toolkit-parser'
utils = require 'express/lib/utils'

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
  constructor: (@routes, @resources, @templates) ->
    for template in @templates
      do (template) ->
        regexp = utils.pathRegexp template.uriTemplate, [], false, false
        template.regexp = regexp

    @httpMethodHandlers =
      get: new ApiKitGetHandler
      post: new ApiKitPostHandler
      put: new ApiKitPutHandler
      delete: new ApiKitDeleteHandler

  getTemplate: (uri) ->
    template = @templates.filter (template) ->
      uri.match(template.regexp)?.length

    if template? and template.length then template[0] else null

  resolve: (req, res) =>
    template = @getTemplate req.url
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
      uriTemplates = toolkitParser.getUriTemplates()

      router = new ApiKitRouter app.routes, resources, uriTemplates
      router.resolve req, res

      next()

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())

app.use apiKit('../leagues/leagues.raml')

# app.get('/teams', (req, res) ->
# 	res.send([{ name: 'All Teams' }])
# )

# app.get('/teams/:id', (req, res) ->
#   res.send({ name: 'by Id' })
# )

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
