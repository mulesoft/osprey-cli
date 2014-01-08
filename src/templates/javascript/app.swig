var express = require('express');
var apiKit = require('apikit-node');

var app = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());
app.use(express.logger('dev'));

apiKit.register('/{{apiPath}}', app, __dirname);

if (!module.parent) {
  app.listen(app.get('port'));
  console.log('listening on port 3000');
}