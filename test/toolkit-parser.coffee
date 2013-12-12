parser = require '../src/toolkit-parser'
should = require 'should'
simplyLog = require 'simply-log'

describe 'TOOLKIT PARSER', ->
  before (done) ->
    @logger = simplyLog.consoleLogger 'raml-toolkit'
    #@logger.setLevel simplyLog.DEBUG

    parser.loadRaml "./examples/leagues/leagues.raml", @logger, (toolkitParser) =>
      @parsedRaml = toolkitParser
      done()

  describe 'RAML PARSER DATA ELEMENT', ->
    it 'Should contain at least base properties: title,version,baseUri', (done)->
      raml = @parsedRaml.getRaml()
      raml.should.have.property 'title', 'La Liga'
      raml.should.have.property 'version', '1.0'
      raml.should.have.property 'baseUri', 'http://localhost:8080/api'
      done()
    it 'Should contain 3 parent resources and 1st resources shoud have 2 methods', (done)->
      raml = @parsedRaml.getRaml()
      raml.should.have.property('resources').with.a.lengthOf(3)
      raml.resources[0].should.have.property('methods').with.a.lengthOf(2)
      done()

  describe 'RESOURCES MAP', ->
    it 'Should have 5 resources', (done) ->
      resources = @parsedRaml.getResources()
      resources.should.be.an.instanceOf Object
      resources.should.have.properties '/teams', '/teams/:teamId', '/positions',
        '/fixture', '/fixture/:homeTeamId/:awayTeamId'
      done()

  describe 'RESOURCES LIST', ->
    it 'Should have 5 resources', (done) ->
      resources = @parsedRaml.getResourcesList()
      resources.should.be.an.instanceOf Object
      resources[0].should.have.property 'uri', '/teams/:teamId'
      resources[1].should.have.property 'uri', '/teams'
      resources[2].should.have.property 'uri', '/positions'
      resources[3].should.have.property 'uri', '/fixture/:homeTeamId/:awayTeamId'
      resources[4].should.have.property 'uri', '/fixture'
      done()

  describe 'SECURITY SCHEMES', ->
    it 'Should have the correct structure of Oauth', (done)->
      schemes = @parsedRaml.getSecuritySchemes()
      schemes[0].should.have.property "oauth_2_0"
      schemes[0]["oauth_2_0"].settings.should.have.property "authorizationUri", "https://www.dropbox.com/1/oauth2/authorize"
      schemes[0]["oauth_2_0"].settings.should.have.property "accessTokenUri", "https://api.dropbox.com/1/oauth2/token"
      schemes[0]["oauth_2_0"].settings.authorizationGrants.should.have.length 2
      schemes[0]["oauth_2_0"].settings.authorizationGrants.should.include "code"
      schemes[0]["oauth_2_0"].settings.authorizationGrants.should.include "token"
      done()

  describe 'PROTOCOLS', ->
    it 'Should return an array with HTTP, HTTPS protocols', (done)->
      protocols = @parsedRaml.getProtocols()
      protocols.should.have.length 2
      protocols.should.include 'HTTPS'
      protocols.should.include 'HTTP'
      done()
