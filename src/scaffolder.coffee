parser = require './wrapper'
swig  = require 'swig'
lingo = require 'lingo'
path = require 'path'

class Scaffolder
  constructor: (@templatePath, @logger, @fileWriter) ->

  generate: (ramlResources, target) =>
    @logger.debug '[Scaffolder] - Starting scaffolder'

    resources = @readResources ramlResources
    @generateBaseApp target, resources
    @generateResources target, resources
    @generateDependenciesFile target
    @generateBuilderFile target

  generateBaseApp: (target, resources) =>
    @logger.debug "[Scaffolder] - Generating base app"

    baseApp = swig.renderFile "#{ @templatePath }/app.swig",
      resources: resources

    try
      @fileWriter.writeFile path.join(target, "app.coffee"), baseApp
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

  generateDependenciesFile: (target) =>
    @logger.debug "[Scaffolder] - Generating Dependencies File"

    try
      dependencies = swig.renderFile path.join(@templatePath, "dependencies.swig")
      @fileWriter.writeFile path.join(target, "package.json"), dependencies
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

  generateBuilderFile: (target) =>
    @logger.debug "[Scaffolder] - Generating Builder File"

    try
      dependencies = swig.renderFile path.join(@templatePath, "builder.swig")
      @fileWriter.writeFile path.join(target, "Gruntfile.coffee"), dependencies
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

  generateResources: (target, resources) =>
    @logger.debug "[Scaffolder] - Generating resources"
    for resource in resources
      do (resource) =>
        @generateResourceFile target, resource

  generateResourceFile: (target, resource) =>
    @logger.debug "[Scaffolder] - Generating #{resource.name} file"

    resourceTemplates = ""

    for template in resource.templates
      do (template) ->
        resourceTemplates += "#{ template }\n\n"

    try
      @fileWriter.writeFile path.join(target, 'resources', "#{ resource.name }.coffee"), resourceTemplates
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

  readResources: (ramlResources) =>
    @logger.debug '[Scaffolder] - Reading RAML resources'

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
    @logger.debug "[Scaffolder] - Rendering #{ method.method } template for #{ baseUri }"

    try
      if method.responses?['200']?.body?['application/json']?.example?
        example = method.responses['200'].body['application/json'].example

      swig.renderFile path.join(@templatePath, "#{ method.method }.swig"),
        uri: baseUri,
        example: example
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

module.exports = Scaffolder
