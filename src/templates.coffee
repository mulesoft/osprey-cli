swig  = require 'swig'
templatePath = 'templates/node/express'

console.log swig.renderFile("#{ templatePath }/get.swig", {
  example: '{ username: req.user.username, email: req.user.email }'
})