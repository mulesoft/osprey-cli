(function() {
  var ParserWrapper, async, clone, ramlLoader, ramlParser, simplyLog;

  ramlParser = require('raml-parser');

  simplyLog = require('simply-log');

  async = require('async');

  ParserWrapper = (function() {
    function ParserWrapper(data, logger) {
      this.logger = logger;
      if (arguments.length === 1) {
        this.logger = simplyLog.consoleLogger('osprey-wrapper');
      }
      this.logger.debug("Building ToolkitParser instance");
      this.raml = data;
      this.resources = {};
      this._generateResources();
    }

    ParserWrapper.prototype.getResources = function() {
      this.logger.debug("Getting Resources");
      return this.resources;
    };

    ParserWrapper.prototype.getUriTemplates = function() {
      var key, resource, templates, _ref;
      this.logger.debug("Getting Uris");
      templates = [];
      _ref = this.resources;
      for (key in _ref) {
        resource = _ref[key];
        templates.push({
          uriTemplate: key
        });
      }
      return templates;
    };

    ParserWrapper.prototype.getResourcesList = function() {
      var key, resource, resourceCopy, resourceList, _ref;
      this.logger.debug("Getting Resources List");
      resourceList = [];
      _ref = this.resources;
      for (key in _ref) {
        resource = _ref[key];
        this.logger.debug("Building Resources Information for resource " + key);
        resourceCopy = clone(resource);
        resourceCopy.uri = key;
        resourceList.push(resourceCopy);
      }
      return resourceList;
    };

    ParserWrapper.prototype.getProtocols = function() {
      return this.raml.protocols;
    };

    ParserWrapper.prototype.getSecuritySchemes = function() {
      return this.raml.securitySchemes;
    };

    ParserWrapper.prototype.getRaml = function() {
      return this.raml;
    };

    ParserWrapper.prototype._generateResources = function() {
      var x, _i, _len, _ref, _results;
      this.logger.debug('Getting Resources from RAML file');
      _ref = this.raml.resources;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        x = _ref[_i];
        _results.push(this._processResource(x, this.resources));
      }
      return _results;
    };

    ParserWrapper.prototype._processResource = function(resource, resourceMap, uri) {
      var uriKey, x, _i, _len, _ref, _ref1;
      if (uri == null) {
        uri = resource.relativeUri;
      }
      this.logger.debug("Getting Resource Information from " + uri);
      if (resource.resources != null) {
        _ref = resource.resources;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          x = _ref[_i];
          this._processResource(x, resourceMap, uri + x.relativeUri);
        }
      }
      uriKey = uri.replace(/{(.*?)}/g, ":$1");
      resourceMap[uriKey] = clone(resource);
      delete resourceMap[uriKey].relativeUri;
      return (_ref1 = resourceMap[uriKey]) != null ? delete _ref1.resources : void 0;
    };

    return ParserWrapper;

  })();

  clone = function(obj) {
    var flags, key, newInstance;
    if ((obj == null) || typeof obj !== 'object') {
      return obj;
    }
    if (obj instanceof Date) {
      return new Date(obj.getTime());
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global != null) {
        flags += 'g';
      }
      if (obj.ignoreCase != null) {
        flags += 'i';
      }
      if (obj.multiline != null) {
        flags += 'm';
      }
      if (obj.sticky != null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    newInstance = new obj.constructor();
    for (key in obj) {
      newInstance[key] = clone(obj[key]);
    }
    return newInstance;
  };

  ramlLoader = function(filePath, loggerObj, callback) {
    if (arguments.length === 2) {
      callback = loggerObj;
      loggerObj = simplyLog.consoleLogger('osprey-wrapper');
    }
    loggerObj.debug("Parsing RAML file " + filePath);
    return ramlParser.loadFile(filePath).then(function(data) {
      loggerObj.debug("RAML file parsed successful!!!!!");
      return callback(new ParserWrapper(data, loggerObj));
    }, function(error) {
      loggerObj.debug("Error parsing: " + error);
      return new Error("Error parsing: " + error);
    });
  };

  exports.loadRaml = async.memoize(ramlLoader);

}).call(this);
