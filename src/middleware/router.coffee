ApiKitGetHandler = require './handlers/get-handler'
ApiKitPostHandler = require './handlers/post-handler'
ApiKitPutHandler = require './handlers/put-handler'
ApiKitDeleteHandler = require './handlers/delete-handler'

class ApiKitRouter
  constructor: (@routes, @resources, @uriTemplateReader) ->
    @httpMethodHandlers =
      get: new ApiKitGetHandler
      post: new ApiKitPostHandler
      put: new ApiKitPutHandler
      delete: new ApiKitDeleteHandler

  resolve: (req, res, next) =>
    # TODO: start using the api endpoint as defined in the raml file
    template = @uriTemplateReader.getTemplateFor req.url
    method = req.method.toLowerCase()

    if template? and not @routerExists method, req.url
      methodInfo = @methodLookup method, template.uriTemplate

      if methodInfo?
        @httpMethodHandlers[method].resolve req, res, methodInfo
        return

    next()

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

module.exports = ApiKitRouter
