ramlParser = require 'raml-parser'
class ToolkitParser
  constructor: (data)->
    @raml = data
    @resources = {}
    @_generateResources()

  getResources: ->
    @resources

  getResourcesList: ->
    resourceList = []
    for key,resource of @resources
      resourceCopy = clone resource
      resourceCopy.uri = key.replace(/{(.*?)}/g,":$1")
      resourceList.push resourceCopy
    resourceList

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

    resourceMap[uri] = clone resource
    delete resourceMap[uri].relativeUri
    delete resourceMap[uri]?.resources



clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime())

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags)

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance


exports.loadRaml = (filePath, callback) ->
  ramlParser.loadFile(filePath).then(
    (data) ->
      callback(new ToolkitParser data)
    ,(error) ->
      console.log('Error parsing: ' + error)
      new Error('Error parsing: ' + error)
  )
