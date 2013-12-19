UriTemplateReader = require './uri-template-reader'
ApiKitRouter = require './router'
parser = require '../toolkit-parser'

module.exports = (raml, routes) ->
  (req, res, next) ->
    parser.loadRaml raml, (toolkitParser) ->
      resources = toolkitParser.getResources()
      templates = toolkitParser.getUriTemplates()
      uriTemplateReader = new UriTemplateReader templates

      router = new ApiKitRouter routes, resources, uriTemplateReader
      router.resolve req, res, next

      next()
