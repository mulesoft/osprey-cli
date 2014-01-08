express = require 'express'
apiKit = require 'apikit-node'

app = module.exports = express()

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()
app.use express.logger('dev')

app.set 'port', process.env.PORT || 3000

apiKit.register '//api', app, __dirname

unless module.parent
  app.listen app.get('port')
  console.log 'listening on port 3000'
