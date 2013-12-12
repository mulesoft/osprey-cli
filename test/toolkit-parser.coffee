parser = require("../src/toolkit-parser")
should = require("should")
parsedRaml = null

describe 'TOOLKIT PARSER', ->
  before (done) ->
    parser.loadRaml "./src/examples/leagues/leagues.raml",(toolkitParser) ->
      parsedRaml = toolkitParser
      done()

  describe 'RAML PARSER DATA ELEMENT', ->
    it 'Should contain at least base properties: title,version,baseUri', (done)->
      raml = parsedRaml.getRaml()
      raml.should.have.property 'title', 'La Liga'
      raml.should.have.property 'version', '1.0'
      raml.should.have.property 'baseUri', 'http://localhost:8080/api'
      done()
    it 'Should contain 3 parent resources and 1st resources shoud have 2 methods', (done)->
      raml = parsedRaml.getRaml()
      raml.should.have.property('resources').with.a.lengthOf(3)
      raml.resources[0].should.have.property('methods').with.a.lengthOf(2)
      done()

  describe 'RESOURCES MAP', ->
    it 'Should have 5 resources', (done) ->
      resources = parsedRaml.getResources()
      resources.should.be.an.instanceOf Object
      resources.should.have.properties '/teams', '/teams/{teamId}', '/positions',
        '/fixture', '/fixture/{homeTeamId}/{awayTeamId}'
      done()

  describe 'RESOURCES LIST', ->
    it 'Should have 5 resources', (done) ->
      resources = parsedRaml.getResourcesList()
      resources.should.be.an.instanceOf Object
      resources[0].should.have.property 'uri', '/teams/:teamId'
      resources[1].should.have.property 'uri', '/teams'
      resources[2].should.have.property 'uri', '/positions'
      resources[3].should.have.property 'uri', '/fixture/:homeTeamId/:awayTeamId'
      resources[4].should.have.property 'uri', '/fixture'
      done()