express = require('express')
http = require('http')
path = require('path')

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)

# toolkitParser.load 'raml', (parser) => {
# 	@parser = parser
# }

# app.middle(ramlValidations (
# 	raml: @parser.getResources
# ))

# class ramlValidations
# 	@constructor: (uri, method) ->
# 		rule rules.findbyuri uri

# 		rule[method]

# rules:
# 	'/leages/:id':
# 		get:
# 			headers:
# 				'content-type': 'application/json'
# 			queryParam:
# 				name:
# 					required: true

# rules[uri][method].queryParam

app.get('/leagues', (req, res) ->
	if this.isValid('/leagues', 'GET')
		res.send({ name: 'test' })
	else
		#anda a la goma
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
