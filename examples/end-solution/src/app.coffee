express = require 'express'
http = require 'http'
path = require 'path'
parser = require '../../../dist/toolkit-parser'

apiKit = (raml) ->
  (req, res, next) ->
    parser.loadRaml raml, (toolkitParser) ->
      resources = toolkitParser.getResources()

      result = app.routes[req.method.toLowerCase()].filter (route) ->
        req.url.match(route.regexp)?.length

      unless result.length
        # TODO: Check if the resource exist in RAML

        if resources[req.url]
          methodInfo = resources[req.url].methods.filter (method) ->
            method.method == req.method.toLowerCase()

          if methodInfo.length
            res.send methodInfo[0].responses?['200']?.body?['application/json']?.example

      next()

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())

app.use apiKit('../leagues/leagues.raml')

# app.get('/teams', (req, res) ->
# 	res.send([{ name: 'All Teams' }])
# )

app.get('/teams/:id', (req, res) ->
  res.send({ name: 'by Id' })
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
