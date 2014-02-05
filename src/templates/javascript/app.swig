var express = require('express');
var path = require('path');
var apiKit = require('apikit-node');

var app = module.exports = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());
app.use(express.logger('dev'));

app.set('port', process.env.PORT || 3000);

apiKit.register('/{{apiPath}}', app, {
  ramlFile: path.join(__dirname, '/assets/raml/api.raml')
});

// Adding business logic to a valid RAML Resource
// apiKit.get('/examples/:exampleId', function(req, res) {
//   res.send({ name: 'example' });
// });

if (!module.parent) {
  var port = app.get('port');
  app.listen(port);
  console.log('listening on port ' + port);
}