UriTemplateReader = require './uri-template-reader'
ApiKitRouter = require './router'
parser = require '../parser-wrapper'
express = require 'express'

ramlEndpoint = (ramlPath) ->
  return (req, res) ->
    if req.accepts('application/raml+yaml')?
      res.sendfile ramlPath
    else
      res.send 406

middleware = (apiPath, ramlPath, routes) ->
  (req, res, next) ->
    if req.path.indexOf(apiPath) >= 0
      parser.loadRaml ramlPath, (wrapper) ->
        resources = wrapper.getResources()
        templates = wrapper.getUriTemplates()
        uriTemplateReader = new UriTemplateReader templates

        router = new ApiKitRouter routes, resources, uriTemplateReader
        router.resolve apiPath, req, res, next
    else
      next()

exports.register = (apiPath, context, path) ->
  context.use middleware(apiPath, path + '/assets/raml/api.raml', context.routes)
  context.use "#{apiPath}/console", express.static(path + '/assets/console')
  context.get apiPath, ramlEndpoint(path + '/assets/raml/api.raml')

exports.ramlEndpoint = ramlEndpoint
exports.middleware = middleware
