parser = require './toolkit-parser'
swig  = require 'swig'

class Scaffolder
  constructor: (@logger, @templatePath) ->

  generate: (resources) ->
    maps = []
    @logger.debug 'Starting scaffolder'

    for resource in resources
      do (resource) =>
        maps.push({ uri: resource.uri, templates: [] })

        for method in resource.methods
          temp = maps[maps.length - 1]
          do (method) =>
            temp.templates.push(
              swig.renderFile "#{ @templatePath }/#{ method.method }.swig", {
                uri: resource.uri,
                example: method.body?['application/json']?.example?
              })

    maps

module.exports = Scaffolder