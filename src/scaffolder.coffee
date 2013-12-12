# TODO: remove this dependency
logger = require 'simply-log'
parser = require './parser/toolkit-parser'

swig  = require 'swig'
templatePath = 'templates/node/express'

class Scaffolder
  constructor: (@logger) ->

  generate: (resources) ->
    maps = []
    @logger.debug 'Starting scaffolder'
    for resource in resources
      do (resource) ->
        maps.push({ uri: resource.uri, templates: [] })
        console.log resource.uri
        for method in resource.methods
          temp = maps[maps.length - 1]
          do (method) ->
            temp.templates.push(
              swig.renderFile "#{ templatePath }/#{ method.method }.swig", {
                uri: resource.uri,
                example: method.body?['application/json']?.example?
              })
            console.log temp

#Example usage
log = logger.consoleLogger 'raml-toolkit'
log.setLevel logger.DEBUG

parser.loadRaml('./examples/leagues/leagues.raml', (toolkitParser) ->
  scaffolder = new Scaffolder log
  scaffolder.generate toolkitParser.getResourcesList()
)
