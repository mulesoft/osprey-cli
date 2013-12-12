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

  describe 'SCAFFOLDER GENERATE BASE APP', ->
    it 'Should correctly generate the base app for Express Templates', (done) ->
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
      )

      scaffolder = new Scaffolder './src/templates/node/express', @logger, fileWriter
      scaffolder.generateBaseApp '/target'

      fileWriter.target.should.eql '/target'
      fileWriter.content.should.eql "express = require('express')\nhttp = require('http')\npath = require('path')\n\napp = express()\n\napp.set('port', process.env.PORT || 3000)\napp.use(express.logger('dev'))\napp.use(express.json())\napp.use(express.bodyParser())\napp.use(express.methodOverride())\napp.use(app.router)\n\nhttp.createServer(app).listen(app.get('port'), () ->\n  console.log('Express server listening on port ' + app.get('port'))\n)\n.coffee"

      done()

  describe 'SCAFFOLDER RENDER TEMPLATE', ->
    it 'Should correctly render a template for GET method', (done) ->
      method =
        method: 'GET'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.get(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for POST method', (done) ->
      method =
        method: 'POST'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.post(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for PUT method', (done) ->
      method =
        method: 'PUT'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.put(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for DELETE method', (done) ->
      method =
        method: 'DELETE'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.delete(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for HEAD method', (done) ->
      method =
        method: 'HEAD'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.head(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for OPTIONS method', (done) ->
      method =
        method: 'OPTIONS'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.options(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for TRACE method', (done) ->
      method =
        method: 'TRACE'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.trace(\'/resource\', (req, res) ->)")

      done()

    it 'Should correctly render a template for PATCH method', (done) ->
      method =
        method: 'PATCH'

      template = @scaffolder.renderTemplateFor method, '/resource'
      template.should.be.type('string')
      template.should.include("app.patch(\'/resource\', (req, res) ->)")

      done()
