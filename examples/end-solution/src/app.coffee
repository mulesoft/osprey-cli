express = require 'express'
http = require 'http'
path = require 'path'
parser = require '../../../dist/toolkit-parser'

class ApiKitRouter
  constructor: (@context, @resources) ->

  defaultGetRoute: (res, uri) =>
    unless @routerExists 'get', uri
      methodInfo = @methodLookup 'get', uri

      if methodInfo?
        res.send methodInfo.responses?['200']?.body?['application/json']?.example

  methodLookup: (httpMethod, uri) =>
    if @resources[uri]?.methods?
      methodInfo = @resources[uri]?.methods.filter (method) ->
        method.method == httpMethod

    if methodInfo? and methodInfo.length then methodInfo[0] else null

  routerExists: (httpMethod, uri) =>
    result = @context.routes[httpMethod].filter (route) ->
      uri.match(route.regexp)?.length

    result.length is 1

apiKit = (raml) ->
  (req, res, next) ->
    parser.loadRaml raml, (toolkitParser) ->
      resources = toolkitParser.getResources()

      router = new ApiKitRouter app, resources

      if req.method == 'GET'
        router.defaultGetRoute res, req.url

      next()

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())

app.use apiKit('../leagues/leagues.raml')

app.get('/teams', (req, res) ->
	res.send([{ name: 'All Teams' }])
)

app.get('/teams/:id', (req, res) ->
  res.send({ name: 'by Id' })
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
