parser = require '../src/toolkit-parser'
Scaffolder = require '../src/scaffolder'
should = require 'should'
simplyLog = require 'simply-log'

describe 'TOOLKIT SCAFFOLDER', ->
  before (done) ->
    @logger = simplyLog.consoleLogger 'raml-toolkit'
    @templatePath = './src/templates/node/express'

    parser.loadRaml "./examples/leagues/leagues.raml", @logger, (toolkitParser) =>
      @parsedRaml = toolkitParser
      @scaffolder = new Scaffolder './src/templates/node/express', @logger, @fileWriter
      done()

  describe 'SCAFFOLDER READ RAML RESOURCES', ->
    it 'Should correctly read RAML resources', (done) ->
      resources = @scaffolder.generate(@parsedRaml.getResourcesList())
      resources.should.have.lengthOf 5

      done()

    it 'Should render templates for each resource', (done) ->
      resources = @scaffolder.generate(@parsedRaml.getResourcesList())
      resources[0].templates.should.have.lengthOf 2
      resources[1].templates.should.have.lengthOf 2
      resources[2].templates.should.have.lengthOf 1
      resources[3].templates.should.have.lengthOf 2
      resources[4].templates.should.have.lengthOf 1

      done()

  describe 'SCAFFOLDER GENERATION', ->
    it 'Should correctly generate the base app for Express Templates', (done) ->
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
      )

      scaffolder = new Scaffolder './src/templates/node/express', @logger, fileWriter
      scaffolder.generateBaseApp '/target', [
        name: 'team'
        uri: '/team'
        methods: [
          { name: 'get'}
          { name: 'post' }
        ]
      ]

      fileWriter.target.should.eql '/target'
      fileWriter.content.should.eql "express = require('express')\nhttp = require('http')\npath = require('path')\n\napp = express()\n\napp.set('port', process.env.PORT || 3000)\napp.use(express.logger('dev'))\napp.use(express.json())\napp.use(express.bodyParser())\napp.use(express.methodOverride())\napp.use(app.router)\n\n\n  \n    app.get('/team', team.get)\n  \n    app.get('/team', team.post)\n  \n\n\nhttp.createServer(app).listen(app.get('port'), () ->\n  console.log('Express server listening on port ' + app.get('port'))\n)\n.coffee"

      done()

    it 'Should correctly generate a resource file', (done) ->
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
      )

      scaffolder = new Scaffolder './src/templates/node/express', @logger, fileWriter
      resources = scaffolder.generate(@parsedRaml.getResourcesList())

      scaffolder.generateResourceFile '/target', resources[0]

      fileWriter.target.should.eql '/target/resources'

      done()

  describe 'SCAFFOLDER RENDERING', ->
    it 'Should correctly render a template for GET method', (done) ->
      method =
        method: 'GET'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.get = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for POST method', (done) ->
      method =
        method: 'POST'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.post = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for PUT method', (done) ->
      method =
        method: 'PUT'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.put = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for DELETE method', (done) ->
      method =
        method: 'DELETE'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.delete = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for HEAD method', (done) ->
      method =
        method: 'HEAD'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.head = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for OPTIONS method', (done) ->
      method =
        method: 'OPTIONS'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.options = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for TRACE method', (done) ->
      method =
        method: 'TRACE'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.trace = function(req, res){\n  //// Add your code here\n};")

      done()

    it 'Should correctly render a template for PATCH method', (done) ->
      method =
        method: 'PATCH'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("exports.patch = function(req, res){\n  //// Add your code here\n};")

      done()
