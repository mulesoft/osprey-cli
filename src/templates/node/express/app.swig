express = require 'express'
http = require 'http'
path = require 'path'
{% for resource in resources %}
{{resource.name}} = require './resources/{{resource.name}}'
{%- endfor %}

app = express()

app.set('port', process.env.PORT || 3000)
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)

{% for resource in resources -%}
{% for method in resource.methods -%}
app.{{method.name}}('{{resource.uri}}', {{resource.name}}.{{method.name}})
{%- endfor %}
{%- endfor %}

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)
