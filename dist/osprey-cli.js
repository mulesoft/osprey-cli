#!/usr/bin/env node
(function() {
  var ArgumentParser, Scaffolder, Table, argParse, config, e, folderStats, fs, listParser, log, logger, newParser, options, parser, path, ramlParser, resourceReader, scaffolder, subparsers, table;

  fs = require('fs.extra');

  path = require('path');

  argParse = require('argparse');

  logger = require('simply-log');

  config = require('../package.json');

  Scaffolder = require('./scaffolder');

  ramlParser = require('raml-parser');

  Table = require('cli-table');

  ArgumentParser = argParse.ArgumentParser;

  parser = new ArgumentParser({
    version: config.version,
    description: 'Osprey Node CLI'
  });

  subparsers = parser.addSubparsers({
    title: 'subcommands',
    dest: "command"
  });

  newParser = subparsers.addParser('new');

  newParser.addArgument(['raml'], {
    nargs: '?',
    help: 'A RAML file path or the path to container folder'
  });

  newParser.addArgument(['-b', '--baseUri'], {
    help: 'Specify base URI for your API',
    defaultValue: '/api',
    metavar: ''
  });

  newParser.addArgument(['-l', '--language'], {
    help: 'Specify output programming language: javascript, coffeescript',
    choices: ['javascript', 'coffeescript'],
    defaultValue: 'javascript',
    metavar: ''
  });

  newParser.addArgument(['-t', '--target'], {
    help: 'Specify output directory',
    metavar: ''
  });

  newParser.addArgument(['-n', '--name'], {
    help: 'Specify application name',
    defaultValue: 'raml-app',
    metavar: ''
  });

  newParser.addArgument(['-v', '--verbose'], {
    help: 'Set the verbose level of output',
    action: 'storeTrue',
    metavar: ''
  });

  newParser.addArgument(['-q', '--quiet'], {
    action: 'storeTrue',
    help: 'Silence commands',
    metavar: ''
  });

  listParser = subparsers.addParser('list');

  listParser.addArgument(['raml'], {
    help: 'A RAML file path or the path to container folder'
  });

  options = parser.parseArgs();

  logger.defaultConsoleAppender = function(name, level, args) {
    if (!console[level]) {
      console[level] = console.log;
    }
    return Function.prototype.apply.call(console[level], console, args);
  };

  log = logger.consoleLogger('osprey-cli');

  log.setLevel(logger.WARN);

  if (options.command === 'new') {
    if (options.verbose) {
      log.setLevel(logger.DEBUG);
      log.debug("Running " + config.name + " " + config.version + "\n");
    }
    if (options.quiet) {
      log.setLevel(logger.OFF);
    }
    log.info('Runtime parameters');
    log.info("  - baseUri: " + options.baseUri);
    log.info("  - language: " + options.language);
    log.info("  - target: " + options.target);
    log.info("  - name: " + options.name);
    log.info("  - raml: " + options.raml);
    log.info(" ");
    if (!options.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)) {
      log.error("ERROR - Invalid base URI: " + options.baseUri);
      log.error(helpTip);
      return 1;
    }
    options.baseUri = options.baseUri.replace(/^\//g, '');
    if (!options.target) {
      options.target = 'output';
      log.warn("WARNING - No target directory was provided. Setting target directory to: " + options.target);
    }
    if (fs.existsSync(options.target)) {
      try {
        fs.rmrfSync(options.target, function(err) {
          return log.debug('Target folder was clean up');
        });
      } catch (_error) {
        e = _error;
        log.error(helpTip);
        return 1;
      }
    }
    try {
      log.debug("Creating directory: " + options.target);
      fs.mkdirSync(options.target);
    } catch (_error) {
      e = _error;
      log.error("ERROR - Unable to create target directory " + progam.target);
      log.error(helpTip);
      return 1;
    }
    folderStats = fs.lstatSync(options.target);
    if (!folderStats.isDirectory) {
      log.error("ERROR - Invalid target directory " + progam.target);
      log.error(helpTip);
      return 1;
    }
    log.debug("Creating src directory");
    fs.mkdirSync(path.join(options.target, 'src'));
    log.debug("Creating assets directory");
    fs.mkdirSync(path.join(options.target, 'src/assets'));
    fs.mkdirSync(path.join(options.target, 'src/assets/raml'));
    log.debug("Creating test directory");
    fs.mkdirSync(path.join(options.target, 'test'));
    if (!options.raml) {
      log.warn("WARNING - No RAML file was provided. A sample RAML file will be used instead.");
    }
    scaffolder = new Scaffolder(log, fs);
    scaffolder.generate(options);
  } else if (options.command === 'list') {
    table = new Table({
      colWidths: [15, 100],
      chars: {
        'top': '',
        'top-mid': '',
        'top-left': '',
        'top-right': '',
        'bottom': '',
        'bottom-mid': '',
        'bottom-left': '',
        'bottom-right': '',
        'left': '',
        'left-mid': '',
        'mid': '',
        'mid-mid': '',
        'right': '',
        'right-mid': '',
        'middle': ' '
      },
      style: {
        'padding-left': 0,
        'padding-right': 0
      }
    });
    resourceReader = function(resources, resourceUri) {
      if (!!resources) {
        return resources.forEach(function(resource) {
          var relativeUri, _ref;
          relativeUri = resourceUri + resource.relativeUri;
          if ((_ref = resource.methods) != null) {
            _ref.forEach(function(method) {
              return table.push([method.method.toUpperCase(), relativeUri]);
            });
          }
          if (!!resource.resources) {
            return resourceReader(resource.resources, relativeUri);
          }
        });
      }
    };
    ramlParser.loadFile(options.raml).then(function(data) {
      resourceReader(data.resources, '');
      return console.log(table.toString());
    }, function(error) {
      return console.log('Error parsing: ' + error);
    });
  }

}).call(this);
