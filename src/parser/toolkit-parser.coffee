ramlParser = require 'raml-parser'
class ToolkitParser
  constructor: (data)->
    @raml = data
    @resources = {}
    @_generateResources()

  getResources: ->
    @resources

  getProtocols: ->
    @raml.protocols

  getSecuritySchemes: ->
    @raml.securitySchemes

  getRaml: ->
    @raml

  _generateResources: ->
    @_processResource x, @resources for x in @raml.resources

  _processResource: (resource, resourceMap, uri) ->
    if not uri?
      uri = resource.relativeUri

    if resource.resources?
      this._processResource x, resourceMap, uri + x.relativeUri for x in resource.resources

    resourceMap[uri] = resource
    delete resourceMap[uri].relativeUri
    delete resourceMap[uri]?.resources


exports.loadRaml = (filePath, callback) ->
  ramlParser.loadFile(filePath).then(
    (data) ->
      callback(new ToolkitParser data)
    ,(error) ->
      console.log('Error parsing: ' + error)
      new Error('Error parsing: ' + error)
  )
