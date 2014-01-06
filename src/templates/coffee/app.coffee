express = require 'express'
http = require 'http'
path = require 'path'
apiKit = require '../../../dist/middleware/apikit-middleware'

app = express()

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()

apiKit.register '/api', app, __dirname

http.createServer(app).listen(3000)
