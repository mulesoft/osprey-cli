parser = require '../src/toolkit-parser'
Scaffolder = require '../src/scaffolder'
should = require 'should'
logger = require 'simply-log'

describe 'TOOLKIT SCAFFOLDER', ->
  before (done) ->
    @log = logger.consoleLogger 'raml-toolkit'
    @templatePath = './src/templates/node/express'

    parser.loadRaml "./src/examples/leagues/leagues.raml", (toolkitParser) =>
      @parsedRaml = toolkitParser
      done()

  describe 'SCAFFOLDER GENERATE', ->
    it 'Should read 5 resources', (done)->
      scaffolder = new Scaffolder @log, './src/templates/node/express'

      maps = scaffolder.generate(@parsedRaml.getResourcesList())
      maps.should.have.lengthOf 5
      done()