# TODO: remove this dependency
logger = require 'simply-log'

swig  = require 'swig'
templatePath = 'templates/node/express'

console.log swig.renderFile("#{ templatePath }/get.swig", {
  example: '{ username: req.user.username, email: req.user.email }'
})

class Scaffolder
  constructor: (@logger) ->

  generate: (resources) ->
    @logger.debug 'Starting scaffolder'
    for resource in resources
      do (resource) ->
        for method in resource.methods
          do (operation) ->
            console.log operation.name
            console.log swig.renderFile "#{ templatePath }/#{ operation.name }.swig", {
              example: 'test'
            }

#Example usage
log = logger.consoleLogger 'raml-toolkit'
log.setLevel logger.DEBUG

scaffolder = new Scaffolder log
scaffolder.generate {
  resources: [{
    uri: '/services',
    operations: [{
      name: 'get'
    }, {
      name: 'post'
    }]
  }, {
    uri: '/consumers',
    operations: []
  }]
}
