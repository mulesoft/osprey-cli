(function() {
  var ApiKitRouter, apiKit, app, express, http, parser, path, utils,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  express = require('express');

  http = require('http');

  path = require('path');

  parser = require('../../../dist/toolkit-parser');

  utils = require('express/lib/utils');

  ApiKitRouter = (function() {
    function ApiKitRouter(context, resources) {
      this.context = context;
      this.resources = resources;
      this.routerExists = __bind(this.routerExists, this);
      this.methodLookup = __bind(this.methodLookup, this);
      this.defaultDeleteRoute = __bind(this.defaultDeleteRoute, this);
      this.defaultPutRoute = __bind(this.defaultPutRoute, this);
      this.defaultPostRoute = __bind(this.defaultPostRoute, this);
      this.defaultGetRoute = __bind(this.defaultGetRoute, this);
    }

    ApiKitRouter.prototype.defaultGetRoute = function(res, uri, template) {
      var methodInfo, _ref, _ref1, _ref2, _ref3;
      if (!this.routerExists('get', uri)) {
        methodInfo = this.methodLookup('get', template);
        if (methodInfo != null) {
          res.contentType('application/json');
          return res.send((_ref = methodInfo.responses) != null ? (_ref1 = _ref['200']) != null ? (_ref2 = _ref1.body) != null ? (_ref3 = _ref2['application/json']) != null ? _ref3.example : void 0 : void 0 : void 0 : void 0, {
            'Content-Type': 'application/json'
          }, 200);
        }
      }
    };

    ApiKitRouter.prototype.defaultPostRoute = function(res, uri, template) {
      var methodInfo;
      if (!this.routerExists('post', uri)) {
        methodInfo = this.methodLookup('post', template);
        if (methodInfo != null) {
          res.contentType('application/json');
          return res.send(201);
        }
      }
    };

    ApiKitRouter.prototype.defaultPutRoute = function(res, uri, template) {
      var methodInfo;
      if (!this.routerExists('put', uri)) {
        methodInfo = this.methodLookup('put', template);
        if (methodInfo != null) {
          return res.send(204);
        }
      }
    };

    ApiKitRouter.prototype.defaultDeleteRoute = function(res, uri, template) {
      var methodInfo;
      if (!this.routerExists('delete', uri)) {
        methodInfo = this.methodLookup('delete', template);
        if (methodInfo != null) {
          return res.send(204);
        }
      }
    };

    ApiKitRouter.prototype.methodLookup = function(httpMethod, uri) {
      var methodInfo, _ref;
      if (((_ref = this.resources[uri]) != null ? _ref.methods : void 0) != null) {
        methodInfo = this.resources[uri].methods.filter(function(method) {
          return method.method === httpMethod;
        });
      }
      if ((methodInfo != null) && methodInfo.length) {
        return methodInfo[0];
      } else {
        return null;
      }
    };

    ApiKitRouter.prototype.routerExists = function(httpMethod, uri) {
      var result;
      if (this.context.routes[httpMethod] != null) {
        result = this.context.routes[httpMethod].filter(function(route) {
          var _ref;
          return (_ref = uri.match(route.regexp)) != null ? _ref.length : void 0;
        });
      }
      return (result != null) && result.length === 1;
    };

    return ApiKitRouter;

  })();

  apiKit = function(raml) {
    return function(req, res, next) {
      return parser.loadRaml(raml, function(toolkitParser) {
        var resources, router, template, uriTemplates, _fn, _i, _len;
        resources = toolkitParser.getResources();
        uriTemplates = toolkitParser.getUriTemplates();
        _fn = function(template) {
          var regexp;
          regexp = utils.pathRegexp(template.uriTemplate, [], false, false);
          return template.regexp = regexp;
        };
        for (_i = 0, _len = uriTemplates.length; _i < _len; _i++) {
          template = uriTemplates[_i];
          _fn(template);
        }
        template = uriTemplates.filter(function(template) {
          var _ref;
          return (_ref = req.url.match(template.regexp)) != null ? _ref.length : void 0;
        });
        if (template.length) {
          router = new ApiKitRouter(app, resources);
          if (req.method === 'GET') {
            router.defaultGetRoute(res, req.url, template[0].uriTemplate);
          }
          if (req.method === 'POST') {
            router.defaultPostRoute(res, req.url, template[0].uriTemplate);
          }
          if (req.method === 'PUT') {
            router.defaultPutRoute(res, req.url, template[0].uriTemplate);
          }
          if (req.method === 'DELETE') {
            router.defaultDeleteRoute(res, req.url, template[0].uriTemplate);
          }
        }
        return next();
      });
    };
  };

  app = express();

  app.set('port', process.env.PORT || 3000);

  app.use(express.logger('dev'));

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(apiKit('../leagues/leagues.raml'));

  http.createServer(app).listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

}).call(this);
