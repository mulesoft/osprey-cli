swig  = require 'swig'

console.log swig.renderFile('templates/get.swig', {
  pagename: 'awesome people',
  authors: ['Paul', 'Jim', 'Jane']
})