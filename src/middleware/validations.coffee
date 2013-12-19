Validation = require './validation/validation'
UriTemplateReader = require './uri-template-reader'
parser = require '../toolkit-parser'

module.exports = (ramlPath, routes) ->
  (req, res, next) ->
    parser.loadRaml ramlPath, (toolkitParser) ->
      resources = toolkitParser.getResources()
      result = routes[req.method.toLowerCase()].filter (route) ->
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