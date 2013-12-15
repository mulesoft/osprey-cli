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

{% for resource in resources %}
  {% for method in resource.methods %}
    app.get('{{resource.uri}}', {{resource.name}}.{{method.name}})
  {% endfor %}
{% endfor %}

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
