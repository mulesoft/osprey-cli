parser = require './toolkit-parser'
swig  = require 'swig'
lingo = require 'lingo'
path = require 'path'

class Scaffolder
  constructor: (@templatePath, @logger, @fileWriter) ->

  generate: (ramlResources, target) =>
    @logger.debug 'Starting scaffolder'
    resources = @readResources ramlResources

  generateBaseApp: (target, resources) =>
    @logger.debug "Generating base app"

    baseApp = swig.renderFile "#{ @templatePath }/app.swig",
      resources: resources

    @fileWriter.writeFile target, "#{ baseApp }.coffee"

  generateResourceFile: (target, resource) =>
    @logger.debug "Generating #{resource.name} file"

    resourceTemplates = ""

    for template in resource.templates
      do (template) ->
        resourceTemplates += template

    @fileWriter.writeFile path.join(target, '/resources'), "#{ resource.name }.coffee"

  readResources: (ramlResources) =>
    @logger.debug 'Reading RAML resources'

    resources = []

    for ramlResource in ramlResources
      do (ramlResource) =>
        resourceName = lingo.camelcase ramlResource.displayName.toLowerCase()

        resource =
          name: resourceName
          uri: ramlResource.uri
          templates: []
          methods: []

        for method in ramlResource.methods
          do (method) =>
            resource.templates.push @renderTemplateFor method, ramlResource.uri
            resource.methods.push { name: method.method }

        resources.push resource

    resources

  renderTemplateFor: (method, baseUri) =>
    @logger.debug "Rendering #{ method.method } template for #{ baseUri }"

    swig.renderFile path.join(@templatePath, "#{ method.method }.swig"),
      uri: baseUri,
      example: method.body?['application/json']?.example?

module.exports = Scaffolder
