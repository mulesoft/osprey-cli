var express = require('express');
var path = require('path');
var osprey = require('osprey');

var app = module.exports = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());
app.use(express.logger('dev'));

app.set('port', process.env.PORT || 3000);

api = osprey.create('/{{apiPath}}', app, {
  ramlFile: path.join(__dirname, '/assets/raml/{{ramlFileName}}'),
  logLevel: 'debug'  //  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all
});

// Adding business logic to a valid RAML Resource
// api.get('/examples/:exampleId', function(req, res) {
//   res.send({ name: 'example' });
// });

if (!module.parent) {
  var port = app.get('port');
  app.listen(port);
  console.log('listening on port ' + port);
}
