(function() {
  var ApiKitRouter, apiKit, app, express, http, parser, path,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  express = require('express');

  http = require('http');

  path = require('path');

  parser = require('../../../dist/toolkit-parser');

  ApiKitRouter = (function() {
    function ApiKitRouter(context, resources) {
      this.context = context;
      this.resources = resources;
      this.routerExists = __bind(this.routerExists, this);
      this.methodLookup = __bind(this.methodLookup, this);
      this.defaultGetRoute = __bind(this.defaultGetRoute, this);
    }

    ApiKitRouter.prototype.defaultGetRoute = function(res, uri) {
      var methodInfo, _ref, _ref1, _ref2, _ref3;
      if (!this.routerExists('get', uri)) {
        methodInfo = this.methodLookup('get', uri);
        if (methodInfo != null) {
          return res.send((_ref = methodInfo.responses) != null ? (_ref1 = _ref['200']) != null ? (_ref2 = _ref1.body) != null ? (_ref3 = _ref2['application/json']) != null ? _ref3.example : void 0 : void 0 : void 0 : void 0);
        }
      }
    };

    ApiKitRouter.prototype.methodLookup = function(httpMethod, uri) {
      var methodInfo, _ref, _ref1;
      if (((_ref = this.resources[uri]) != null ? _ref.methods : void 0) != null) {
        methodInfo = (_ref1 = this.resources[uri]) != null ? _ref1.methods.filter(function(method) {
          return method.method === httpMethod;
        }) : void 0;
      }
      if ((methodInfo != null) && methodInfo.length) {
        return methodInfo[0];
      } else {
        return null;
      }
    };

    ApiKitRouter.prototype.routerExists = function(httpMethod, uri) {
      var result;
      result = this.context.routes[httpMethod].filter(function(route) {
        var _ref;
        return (_ref = uri.match(route.regexp)) != null ? _ref.length : void 0;
      });
      return result.length === 1;
    };

    return ApiKitRouter;

  })();

  apiKit = function(raml) {
    return function(req, res, next) {
      return parser.loadRaml(raml, function(toolkitParser) {
        var resources, router;
        resources = toolkitParser.getResources();
        router = new ApiKitRouter(app, resources);
        if (req.method === 'GET') {
          router.defaultGetRoute(res, req.url);
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
