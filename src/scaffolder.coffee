parser = require './toolkit-parser'
swig  = require 'swig'

class Scaffolder
  constructor: (@templatePath, @logger) ->

  generate: (resources) =>
    @logger.debug 'Starting scaffolder'
    @readResources resources

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

module.exports = Scaffolder