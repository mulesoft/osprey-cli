swig  = require 'swig'
templatePath = 'templates/node/express'

console.log swig.renderFile("#{ templatePath }/get.swig", {
  example: '{ username: req.user.username, email: req.user.email }'
})

class Scaffolder
  constructor: (@logger) ->

  generate: ->
    console.log 'hola'

#Example usage
scaffolder = new Scaffolder "Sammy the Python"

scaffolder.generate()
