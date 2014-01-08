# parser = require '../src/wrapper'
# Scaffolder = require '../src/scaffolder'
# should = require 'should'
# simplyLog = require 'simply-log'

# describe 'TOOLKIT SCAFFOLDER', ->
#   before (done) ->
#     @logger = simplyLog.consoleLogger 'apikit'
#     @templatePath = './src/templates/node/express'

#     @fileWriter = new (class FileWriter
#         writeFile:  (target, content) =>
#           @target = target
#           @content = content
#       )

#     parser.loadRaml "./test/assets/leagues/leagues.raml", @logger, (wrapper) =>
#       @parsedRaml = wrapper
#       @scaffolder = new Scaffolder './src/templates/node/express', @logger, @fileWriter
#       done()

#   describe 'SCAFFOLDER READ RAML RESOURCES', ->
#     it 'Should correctly read RAML resources', (done) ->
#       # Act
#       resources = @scaffolder.readResources(@parsedRaml.getResourcesList())

#       # Assert
#       resources.should.have.lengthOf 5

#       done()

#     it 'Should render templates for each resource', (done) ->
#       # Act
#       resources = @scaffolder.readResources(@parsedRaml.getResourcesList())

#       # Assert
#       resources[0].templates.should.have.lengthOf 2
#       resources[1].templates.should.have.lengthOf 2
#       resources[2].templates.should.have.lengthOf 1
#       resources[3].templates.should.have.lengthOf 2
#       resources[4].templates.should.have.lengthOf 1

#       done()

#   describe 'SCAFFOLDER GENERATION', ->
#     it 'Should correctly generate the base app for Express Templates', (done) ->
#       # Arrange
#       fileWriter = new (class FileWriter
#         writeFile:  (target, content) =>
#           @target = target
#           @content = content
#       )

#       scaffolder = new Scaffolder './src/templates/node/express', @logger, fileWriter

#       # Act
#       scaffolder.generateBaseApp '/target', [
#         name: 'team'
#         uri: '/team'
#         methods: [
#           { name: 'get'}
#           { name: 'post' }
#         ]
#       ]

#       # Assert
#       fileWriter.target.should.eql '/target/app.coffee'
#       fileWriter.content.should.eql "express = require 'express'\nhttp = require 'http'\npath = require 'path'\n\nteam = require './resources/team'\n\napp = express()\n\napp.set('port', process.env.PORT || 3000)\napp.use(express.logger('dev'))\napp.use(express.json())\napp.use(express.bodyParser())\napp.use(express.methodOverride())\napp.use(app.router)\n\napp.get('/team', team.get)\napp.post('/team', team.post)\n\n\nhttp.createServer(app).listen(app.get('port'), () ->\n  console.log('Express server listening on port ' + app.get('port'))\n)\n"

#       done()

#     it 'Should correctly generate a resource file', (done) ->
#       # Arrange
#       fileWriter = new (class FileWriter
#         writeFile:  (target, content) =>
#           @target = target
#           @content = content
#       )

#       scaffolder = new Scaffolder './src/templates/node/express', @logger, fileWriter
#       resources = scaffolder.readResources(@parsedRaml.getResourcesList())

#       # Act
#       scaffolder.generateResourceFile '/target', resources[0]

#       # Assert
#       fileWriter.target.should.eql '/target/resources/team.coffee'

#       done()

#   describe 'SCAFFOLDER RENDERING', ->
#     it 'Should correctly render a template for GET method', (done) ->
#       # Arrange
#       method =
#         method: 'GET'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.get = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for POST method', (done) ->
#       # Arrange
#       method =
#         method: 'POST'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.post = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for PUT method', (done) ->
#       # Arrange
#       method =
#         method: 'PUT'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.put = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for DELETE method', (done) ->
#       # Arrange
#       method =
#         method: 'DELETE'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.delete = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for HEAD method', (done) ->
#       # Arrange
#       method =
#         method: 'HEAD'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.head = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for OPTIONS method', (done) ->
#       # Arrange
#       method =
#         method: 'OPTIONS'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.options = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for TRACE method', (done) ->
#       # Arrange
#       method =
#         method: 'TRACE'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.trace = (req, res) ->\n  #Add your code here")

#       done()

#     it 'Should correctly render a template for PATCH method', (done) ->
#       # Arrange
#       method =
#         method: 'PATCH'

#       # Act
#       template = @scaffolder.renderTemplateFor method, '/resource'

#       # Assert
#       template.should.be.type('string')
#       template.should.include("exports.patch = (req, res) ->\n  #Add your code here")

#       done()
