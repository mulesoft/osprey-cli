(function() {
  var ApiKitDeleteHandler, ApiKitGetHandler, ApiKitPostHandler, ApiKitPutHandler, ApiKitRouter, apiKit, app, express, http, parser, path, utils,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  express = require('express');

  http = require('http');

  path = require('path');

  parser = require('../../../dist/toolkit-parser');

  utils = require('express/lib/utils');

  ApiKitGetHandler = (function() {
    function ApiKitGetHandler() {
      this.resolve = __bind(this.resolve, this);
    }

    ApiKitGetHandler.prototype.resolve = function(req, res, methodInfo) {
      var _ref, _ref1, _ref2, _ref3;
      res.contentType('application/json');
      return res.send((_ref = methodInfo.responses) != null ? (_ref1 = _ref['200']) != null ? (_ref2 = _ref1.body) != null ? (_ref3 = _ref2['application/json']) != null ? _ref3.example : void 0 : void 0 : void 0 : void 0, {
        'Content-Type': 'application/json'
      }, 200);
    };

    return ApiKitGetHandler;

  })();

  ApiKitPostHandler = (function() {
    function ApiKitPostHandler() {
      this.resolve = __bind(this.resolve, this);
    }

    ApiKitPostHandler.prototype.resolve = function(req, res, methodInfo) {
      res.contentType('application/json');
      return res.send(201);
    };

    return ApiKitPostHandler;

  })();

  ApiKitPutHandler = (function() {
    function ApiKitPutHandler() {
      this.resolve = __bind(this.resolve, this);
    }

    ApiKitPutHandler.prototype.resolve = function(req, res, methodInfo) {
      return res.send(204);
    };

    return ApiKitPutHandler;

  })();

  ApiKitDeleteHandler = (function() {
    function ApiKitDeleteHandler() {
      this.resolve = __bind(this.resolve, this);
    }

    ApiKitDeleteHandler.prototype.resolve = function(req, res, methodInfo) {
      return res.send(204);
    };

    return ApiKitDeleteHandler;

  })();

  ApiKitRouter = (function() {
    function ApiKitRouter(routes, resources, templates) {
      var template, _fn, _i, _len, _ref;
      this.routes = routes;
      this.resources = resources;
      this.templates = templates;
      this.routerExists = __bind(this.routerExists, this);
      this.methodLookup = __bind(this.methodLookup, this);
      this.resolve = __bind(this.resolve, this);
      _ref = this.templates;
      _fn = function(template) {
        var regexp;
        regexp = utils.pathRegexp(template.uriTemplate, [], false, false);
        return template.regexp = regexp;
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        template = _ref[_i];
        _fn(template);
      }
      this.httpMethodHandlers = {
        get: new ApiKitGetHandler,
        post: new ApiKitPostHandler,
        put: new ApiKitPutHandler,
        "delete": new ApiKitDeleteHandler
      };
    }

    ApiKitRouter.prototype.getTemplate = function(uri) {
      var template;
      template = this.templates.filter(function(template) {
        var _ref;
        return (_ref = uri.match(template.regexp)) != null ? _ref.length : void 0;
      });
      if ((template != null) && template.length) {
        return template[0];
      } else {
        return null;
      }
    };

    ApiKitRouter.prototype.resolve = function(req, res) {
      var method, methodInfo, template;
      template = this.getTemplate(req.url);
      method = req.method.toLowerCase();
      if ((template != null) && !this.routerExists(method, req.url)) {
        console.log('unless');
        methodInfo = this.methodLookup(method, template.uriTemplate);
        if (methodInfo != null) {
          return this.httpMethodHandlers[method].resolve(req, res, methodInfo);
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
      if (this.routes[httpMethod] != null) {
        result = this.routes[httpMethod].filter(function(route) {
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
        var resources, router, uriTemplates;
        resources = toolkitParser.getResources();
        uriTemplates = toolkitParser.getUriTemplates();
        router = new ApiKitRouter(app.routes, resources, uriTemplates);
        router.resolve(req, res);
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
