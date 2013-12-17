(function() {
  var app, express, http, path;

  express = require('express');

  http = require('http');

  path = require('path');

  app = express();

  app.set('port', process.env.PORT || 3000);

  app.use(express.logger('dev'));

  app.use(express.json());

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(function(req, res, next) {
    var result;
    result = app.routes[req.method.toLowerCase()].filter(function(route) {
      var _ref;
      return (_ref = req.url.match(route.regexp)) != null ? _ref.length : void 0;
    });
    if (!result.length) {
      res.send({
        name: 'fucking yeah!'
      });
    }
    return next();
  });

  app.get('/teams', function(req, res) {
    return res.send([
      {
        name: 'All Teams'
      }
    ]);
  });

  app.get('/teams/:id', function(req, res) {
    return res.send({
      name: 'by Id'
    });
  });

  http.createServer(app).listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

}).call(this);
