(function() {
  var Scaffolder, lingo, parser, path, swig,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  parser = require('./wrapper');

  swig = require('swig');

  lingo = require('lingo');

  path = require('path');

  Scaffolder = (function() {
    function Scaffolder(logger, fileWriter) {
      this.logger = logger;
      this.fileWriter = fileWriter;
      this.write = __bind(this.write, this);
      this.copyRaml = __bind(this.copyRaml, this);
      this.createGruntfile = __bind(this.createGruntfile, this);
      this.createPackage = __bind(this.createPackage, this);
      this.createApp = __bind(this.createApp, this);
      this.generate = __bind(this.generate, this);
    }

    Scaffolder.prototype.generate = function(options) {
      var fileType;
      this.logger.debug('[Scaffolder] - Starting scaffolder');
      fileType = options.language === 'javascript' ? 'js' : 'coffee';
      this.createApp(options, fileType);
      this.createGruntfile(options, fileType);
      this.createPackage(options);
      return this.copyRaml(options);
    };

    Scaffolder.prototype.createApp = function(options, fileType) {
      var params, templatePath;
      this.logger.debug("[Scaffolder] - Generating app." + fileType);
      templatePath = path.join(__dirname, 'templates', options.language, 'app.swig');
      params = {
        apiPath: options.baseUri
      };
      return this.write(path.join(options.target, "src/app." + fileType), this.render(templatePath, params));
    };

    Scaffolder.prototype.createPackage = function(options) {
      var params, templatePath;
      this.logger.debug("[Scaffolder] - Generating Package.json");
      templatePath = path.join(__dirname, 'templates', options.language, 'package.swig');
      params = {
        appName: options.name
      };
      return this.write(path.join(options.target, 'package.json'), this.render(templatePath, params));
    };

    Scaffolder.prototype.createGruntfile = function(options, fileType) {
      var src, target,
        _this = this;
      src = path.join(__dirname, 'templates', options.language, 'Gruntfile.swig');
      target = path.join(options.target, "Gruntfile." + fileType);
      return this.fileWriter.copy(src, target, function(err) {
        return _this.logger.debug("[Scaffolder] - Generating Gruntfile");
      });
    };

    Scaffolder.prototype.copyRaml = function(options) {
      var dest, params, source, templatePath;
      this.logger.debug("[Scaffolder] - Generating RAML file");
      if (!options.raml) {
        templatePath = path.join(__dirname, 'templates/common/raml.swig');
        params = {
          appName: options.name
        };
        return this.write(path.join(options.target, 'src/assets/raml/api.raml'), this.render(templatePath, params));
      } else {
        source = options.raml;
        dest = path.join(options.target, 'src/assets/raml');
        if (this.fileWriter.lstatSync(source).isDirectory()) {
          return this.fileWriter.copyRecursive(source, dest, function(err) {});
        } else {
          dest = path.join(dest, path.basename(source));
          return this.fileWriter.copy(source, dest, function(err) {});
        }
      }
    };

    Scaffolder.prototype.render = function(templatePath, params) {
      return swig.renderFile(templatePath, params);
    };

    Scaffolder.prototype.write = function(path, data) {
      var e;
      try {
        return this.fileWriter.writeFile(path, data);
      } catch (_error) {
        e = _error;
        return this.logger.debug("[Scaffolder] - " + e.message);
      }
    };

    return Scaffolder;

  })();

  module.exports = Scaffolder;

}).call(this);
