(function() {
  var apiKit, app, express, http, parser, path;

  express = require('express');

  http = require('http');

  path = require('path');

  parser = require('../../../dist/toolkit-parser');

  apiKit = function(raml) {
    return function(req, res, next) {
      return parser.loadRaml(raml, function(toolkitParser) {
        var methodInfo, resources, result, _ref, _ref1, _ref2, _ref3;
        resources = toolkitParser.getResources();
        result = app.routes[req.method.toLowerCase()].filter(function(route) {
          var _ref;
          return (_ref = req.url.match(route.regexp)) != null ? _ref.length : void 0;
        });
        if (!result.length) {
          if (resources[req.url]) {
            methodInfo = resources[req.url].methods.filter(function(method) {
              return method.method === req.method.toLowerCase();
            });
            if (methodInfo.length) {
              res.send((_ref = methodInfo[0].responses) != null ? (_ref1 = _ref['200']) != null ? (_ref2 = _ref1.body) != null ? (_ref3 = _ref2['application/json']) != null ? _ref3.example : void 0 : void 0 : void 0 : void 0);
            }
          }
        }
        return next();
      });
    };
  };

  app = express();

  app.set('port', process.env.PORT || 3000);

  app.use(express.logger('dev'));

  app.use(express.json());

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(apiKit('../leagues/leagues.raml'));

  app.get('/teams/:id', function(req, res) {
    return res.send({
      name: 'by Id'
    });
  });

  http.createServer(app).listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

}).call(this);
