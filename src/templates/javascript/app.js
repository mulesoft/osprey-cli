var express = require('express');
var http = require('http');
var path = require('path');
var apiKit = require('../../../dist/middleware/api-kit');

var app = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());

apiKit.register('/api', app, __dirname);

http.createServer(app).listen(3000);