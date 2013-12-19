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

    contentTypes = {}
    # TODO: Fix coneg
    for mimeType of methodInfo.responses?['200']?.body
      contentTypes[mimeType] = do (mimeType) ->
        res.send methodInfo.responses?['200']?.body?[mimeType].example, { 'Content-Type': mimeType }, 200

    res.format contentTypes

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

app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.compress());

# APIKit Configuration
app.use apiKit(__dirname + '/assets/raml/api.raml')

# TODO: This should be move to the apikit runtime
# TODO: Ask for an stable version of the console!
app.use '/api/console', express.static(__dirname + '/assets/console')

# TODO: Base Url should be replace
# TODO: It should check for application/raml+yaml
app.use '/api', express.static(__dirname + '/assets/raml')

http.createServer(app).listen(3000)
