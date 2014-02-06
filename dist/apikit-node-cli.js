(function() {
  var Scaffolder, config, e, folderStats, fs, helpTip, log, logger, path, program, ramlFile, scaffolder, _ref;

  logger = require('simply-log');

  logger.defaultConsoleAppender = function(name, level, args) {
    if (!console[level]) {
      console[level] = console.log;
    }
    return Function.prototype.apply.call(console[level], console, args);
  };

  log = logger.consoleLogger('apikit-node');

  log.setLevel(logger.WARN);

  fs = require('fs.extra');

  path = require('path');

  program = require('commander');

  config = require('../package.json');

  program.version(config.version);

  program.usage('new <raml-file or path-to-raml> [options]');

  program.option('-b, --baseUri [uri]', 'specify base URI for your API', '/api');

  program.option('-l, --language [language]', 'specify output programming language: javascript, coffeescript', 'javascript');

  program.option('-t, --target [directory]', 'specify output directory');

  program.option('-n, --name [app-name]', 'specify application name', 'raml-app');

  program.option('-v, --verbose', 'set the verbose level of output');

  program.option('-q, --quiet', 'silence commands');

  program.on('--help', function() {
    var file;
    file = fs.readFileSync("" + __dirname + "/assets/help.txt", 'utf8');
    return log.info(file);
  });

  helpTip = '\nUse -h or --help for more information.';

  program.parse(process.argv);

  if (program.args[0] === 'new') {
    if (program.verbose) {
      log.setLevel(logger.DEBUG);
      log.debug("Running " + config.name + " " + config.version + "\n");
    }
    if (program.quiet) {
      log.setLevel(logger.OFF);
    }
    log.info('Runtime parameters');
    log.info("  - baseUri: " + program.baseUri);
    log.info("  - language: " + program.language);
    if (program.target) {
      log.info("  - target: " + program.target);
    }
    log.info("  - name: " + program.name);
    if (program.args.length > 0) {
      log.info("  - args: " + program.args);
    }
    log.info(" ");
    if (!program.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)) {
      log.error("ERROR - Invalid base URI: " + program.baseUri);
      log.error(helpTip);
      return 1;
    }
    program.baseUri = program.baseUri.replace(/^\//g, '');
    if ((_ref = program.language) !== 'javascript' && _ref !== 'coffeescript') {
      log.error("ERROR - Invalid output language type: " + program.language);
      log.error(helpTip);
      return 1;
    }
    if (!program.target) {
      program.target = 'output';
      log.warn("WARNING - No target directory was provided. Setting target directory to: " + program.target);
    }
    if (fs.existsSync(program.target)) {
      try {
        fs.rmrfSync(program.target, function(err) {
          return log.debug('Target folder was clean up');
        });
      } catch (_error) {
        e = _error;
        log.error(helpTip);
        return 1;
      }
    }
    try {
      log.debug("Creating directory: " + program.target);
      fs.mkdirSync(program.target);
    } catch (_error) {
      e = _error;
      log.error("ERROR - Unable to create target directory " + progam.target);
      log.error(helpTip);
      return 1;
    }
    folderStats = fs.lstatSync(program.target);
    if (!folderStats.isDirectory) {
      log.error("ERROR - Invalid target directory " + progam.target);
      log.error(helpTip);
      return 1;
    }
    log.debug("Creating src directory");
    fs.mkdirSync(path.join(program.target, 'src'));
    log.debug("Creating assets directory");
    fs.mkdirSync(path.join(program.target, 'src/assets'));
    fs.mkdirSync(path.join(program.target, 'src/assets/raml'));
    log.debug("Creating test directory");
    fs.mkdirSync(path.join(program.target, 'test'));
    if (program.args.length === 1) {
      log.warn("WARNING - No RAML file was provided. A sample RAML file will be used instead.");
      ramlFile = null;
    } else {
      ramlFile = program.args[2];
    }
    if (program.args.length > 2) {
      log.error("ERROR - Invalid set of parameters.");
      log.error(helpTip);
      return 1;
    }
    Scaffolder = require('./scaffolder');
    scaffolder = new Scaffolder(log, fs);
    scaffolder.generate(program);
  } else {
    program.help();
  }

}).call(this);
