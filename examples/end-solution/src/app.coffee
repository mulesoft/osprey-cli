express = require 'express'
http = require 'http'
path = require 'path'

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())

app.use (req, res, next) ->
  result = app.routes[req.method.toLowerCase()].filter (route) ->
    req.url.match(route.regexp)?.length

  unless result.length
    # TODO: Check if the resource exist in RAML
    res.send({ name: 'fucking yeah!' })

  next()

app.get('/teams', (req, res) ->
	res.send([{ name: 'All Teams' }])
)

app.get('/teams/:id', (req, res) ->
  res.send({ name: 'by Id' })
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
