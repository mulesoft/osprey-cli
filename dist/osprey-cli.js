#!/usr/bin/env node
(function() {
  var ArgumentParser, Scaffolder, Table, argParse, config, e, folderFiles, folderStats, fs, helpTip, listParser, logger, newParser, options, parser, path, ramlParser, resourceReader, scaffolder, subparsers, table, tips;

  fs = require('fs.extra');

  path = require('path');

  argParse = require('argparse');

  config = require('../package.json');

  Scaffolder = require('./scaffolder');

  ramlParser = require('raml-parser');

  Table = require('cli-table');

  logger = require('./utils/logger');

  tips = require('./assets/help.json');

  ArgumentParser = argParse.ArgumentParser;

  helpTip = tips["new"];

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
    required: true,
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

  logger.setLevel('info');

  if (options.command === 'new') {
    if (options.verbose) {
      logger.info("Running " + config.name + " " + config.version + "\n");
    }
    if (options.quiet) {
      logger.setLevel('off');
    }
    logger.info("Runtime parameters");
    logger.info("  - baseUri: " + options.baseUri);
    logger.info("  - language: " + options.language);
    logger.info("  - target: " + options.target);
    logger.info("  - name: " + options.name);
    logger.info("  - raml: " + options.raml);
    logger.info(" ");
    if (!options.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)) {
      logger.error("ERROR - Invalid base URI: " + options.baseUri);
      logger.error(helpTip);
      return 1;
    }
    options.baseUri = options.baseUri.replace(/^\//g, '');
    if (!options.target) {
      options.target = process.cwd();
      logger.warn("WARNING - No target directory was provided. Setting target directory to: " + options.target);
    }
    if (fs.existsSync(options.raml)) {
      folderStats = fs.lstatSync(options.raml);
      if (folderStats.isDirectory) {
        if (options.target.indexOf(options.raml) !== -1) {
          logger.error("ERROR - The target folder could not be a subfolder of the raml file path.");
          logger.error("Target  : " + options.target);
          logger.error("RamlPath: " + options.raml);
          return 1;
        }
      }
    }
    if (fs.existsSync(options.target)) {
      folderStats = fs.lstatSync(options.target);
      folderFiles = fs.readdirSync(options.target);
      if (folderFiles.length !== 0) {
        logger.error("ERROR - The target must be empty");
        return 1;
      }
      if (!folderStats.isDirectory) {
        logger.error("ERROR - Invalid target directory " + options.target);
        return 1;
      }
    } else {
      try {
        logger.debug("Creating directory: " + options.target);
        fs.mkdirSync(options.target);
      } catch (_error) {
        e = _error;
        logger.error("ERROR - Unable to create target directory " + options.target);
        return 1;
      }
    }
    logger.debug("Creating src directory");
    fs.mkdirSync(path.join(options.target, 'src'));
    logger.debug("Creating assets directory");
    fs.mkdirSync(path.join(options.target, 'src/assets'));
    fs.mkdirSync(path.join(options.target, 'src/assets/raml'));
    logger.debug("Creating test directory");
    fs.mkdirSync(path.join(options.target, 'test'));
    if (!options.raml) {
      logger.warn("WARNING - No RAML file was provided. A sample RAML file will be used instead.");
    }
    scaffolder = new Scaffolder(logger, fs);
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
      return logger.error('Error parsing: ' + error);
    });
  }

}).call(this);
