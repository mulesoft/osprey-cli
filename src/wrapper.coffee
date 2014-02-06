ramlParser = require 'raml-parser'
simplyLog = require 'simply-log'
async = require 'async'

class ParserWrapper
  constructor: (data, @logger)->
    @logger = simplyLog.consoleLogger 'osprey-wrapper' if arguments.length == 1
    @logger.debug "Building ToolkitParser instance"
    @raml = data
    @resources = {}
    @_generateResources()

  getResources: ->
    @logger.debug "Getting Resources"
    @resources

  getUriTemplates: ->
    @logger.debug "Getting Uris"
    templates = []

    for key,resource of @resources
      templates.push { uriTemplate: key }

    templates

  getResourcesList: ->
    @logger.debug "Getting Resources List"
    resourceList = []
    for key,resource of @resources
      @logger.debug "Building Resources Information for resource #{key}"
      resourceCopy = clone resource
      resourceCopy.uri = key
      resourceList.push resourceCopy
    resourceList

  getProtocols: ->
    @raml.protocols

  getSecuritySchemes: ->
    @raml.securitySchemes

  getRaml: ->
    @raml

  _generateResources: ->
    @logger.debug 'Getting Resources from RAML file'
    @_processResource x, @resources for x in @raml.resources

  _processResource: (resource, resourceMap, uri) ->
    if not uri?
      uri = resource.relativeUri

    @logger.debug "Getting Resource Information from #{ uri }"

    if resource.resources?
      this._processResource x, resourceMap, uri + x.relativeUri for x in resource.resources

    uriKey = uri.replace /{(.*?)}/g,":$1"
    resourceMap[uriKey] = clone resource
    delete resourceMap[uriKey].relativeUri
    delete resourceMap[uriKey]?.resources

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

ramlLoader = (filePath, loggerObj, callback) ->
  if arguments.length == 2
    callback = loggerObj
    loggerObj = simplyLog.consoleLogger 'osprey-wrapper'

  loggerObj.debug "Parsing RAML file #{filePath}"
  ramlParser.loadFile(filePath).then(
    (data) ->
      loggerObj.debug "RAML file parsed successful!!!!!"
      callback(new ParserWrapper data, loggerObj)
    ,(error) ->
      loggerObj.debug "Error parsing: #{error}"
      new Error "Error parsing: #{error}"
  )

exports.loadRaml = async.memoize ramlLoader
