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

middleware = (ramlPath, routes) ->
  (req, res, next) ->
    parser.loadRaml ramlPath, (wrapper) ->
      resources = wrapper.getResources()
      templates = wrapper.getUriTemplates()
      uriTemplateReader = new UriTemplateReader templates

      router = new ApiKitRouter routes, resources, uriTemplateReader
      router.resolve req, res, next

exports.register = (context, path) ->
  context.use middleware(path + '/assets/raml/api.raml', context.routes)
  context.use '/api/console', express.static(path + '/assets/console')
  context.get '/api', ramlEndpoint(path + '/assets/raml/api.raml')

exports.ramlEndpoint = ramlEndpoint
exports.middleware = middleware
