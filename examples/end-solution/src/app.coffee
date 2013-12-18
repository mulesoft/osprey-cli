express = require 'express'
http = require 'http'
path = require 'path'
parser = require '../../../dist/toolkit-parser'
utils = require 'express/lib/utils'

class ApiKitRouter
  constructor: (@context, @resources) ->

  defaultGetRoute: (res, uri, template) =>
    unless @routerExists 'get', uri
      methodInfo = @methodLookup 'get', template

      if methodInfo?
        # TODO: Add validations
        # TODO: Add content negociation
        res.contentType('application/json');
        res.send methodInfo.responses?['200']?.body?['application/json']?.example, { 'Content-Type': 'application/json' }, 200

  defaultPostRoute: (res, uri, template) =>
    unless @routerExists 'post', uri
      methodInfo = @methodLookup 'post', template

      if methodInfo?
        # TODO: Add validations
        # TODO: Add content negociation
        res.contentType('application/json');
        res.send 201

  defaultPutRoute: (res, uri, template) =>
    unless @routerExists 'put', uri
      methodInfo = @methodLookup 'put', template

      if methodInfo?
        # TODO: Add validations
        res.send 204

  defaultDeleteRoute: (res, uri, template) =>
    unless @routerExists 'delete', uri
      methodInfo = @methodLookup 'delete', template

      if methodInfo?
        # TODO: Add validations
        res.send 204

  methodLookup: (httpMethod, uri) =>
    if @resources[uri]?.methods?
      methodInfo = @resources[uri].methods.filter (method) ->
        method.method == httpMethod

    if methodInfo? and methodInfo.length then methodInfo[0] else null

  routerExists: (httpMethod, uri) =>
    if @context.routes[httpMethod]?
      result = @context.routes[httpMethod].filter (route) ->
        uri.match(route.regexp)?.length

    result? and result.length is 1

apiKit = (raml) ->
  (req, res, next) ->
    parser.loadRaml raml, (toolkitParser) ->
      resources = toolkitParser.getResources()
      uriTemplates = toolkitParser.getUriTemplates()

      for template in uriTemplates
        do (template) ->
          regexp = utils.pathRegexp template.uriTemplate, [], false, false
          template.regexp = regexp

      template = uriTemplates.filter (template) ->
        req.url.match(template.regexp)?.length

      if template.length
        router = new ApiKitRouter app, resources

        if req.method == 'GET'
          router.defaultGetRoute res, req.url, template[0].uriTemplate

        if req.method == 'POST'
          router.defaultPostRoute res, req.url, template[0].uriTemplate

        if req.method == 'PUT'
          router.defaultPutRoute res, req.url, template[0].uriTemplate

        if req.method == 'DELETE'
          router.defaultDeleteRoute res, req.url, template[0].uriTemplate

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
