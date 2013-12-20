Validation = require './validation/validation'
UriTemplateReader = require './uri-template-reader'
parser = require '../parser-wrapper'

module.exports = (ramlPath, routes) ->
  (req, res, next) ->
    parser.loadRaml ramlPath, (wrapper) ->
      resources = wrapper.getResources()
      result = routes[req.method.toLowerCase()].filter (route) ->
        req.url.match(route.regexp)?.length

      if result.length
        resource = resources[result[0].path]

        templates = wrapper.getUriTemplates()

        uriTemplateReader = new UriTemplateReader templates

        validation = new Validation req, uriTemplateReader, resource
        if not validation.isValid()
          res.status('400')
          return

      next()
