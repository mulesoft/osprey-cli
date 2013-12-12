parser = require './toolkit-parser'
swig  = require 'swig'

class Scaffolder
  constructor: (@templatePath, @logger, @fileWriter) ->

  generate: (ramlResources, target) =>
    @logger.debug 'Starting scaffolder'
    resources = @readResources ramlResources

  readResources: (ramlResources) =>
    @logger.debug 'Reading RAML resources'

    resources = []

    for ramlResource in ramlResources
      do (ramlResource) =>
        resource = { uri: ramlResource.uri, templates: [] }

        for method in ramlResource.methods
          do (method) =>
            resource.templates.push @renderTemplateFor method, ramlResource.uri

        resources.push resource

    resources

  renderTemplateFor: (method, baseUri) =>
    @logger.debug "Rendering #{ method.method } template for #{ baseUri }"

    swig.renderFile "#{ @templatePath }/#{ method.method }.swig",
      uri: baseUri,
      example: method.body?['application/json']?.example?

  generateBaseApp: (target) =>
    baseApp = swig.renderFile "#{ @templatePath }/app.swig"
    @fileWriter.writeFile target, "#{ baseApp }.coffee"

module.exports = Scaffolder
