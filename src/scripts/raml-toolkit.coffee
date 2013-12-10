#!/usr/bin/env node

# Set up logger
logger = require 'simply-log'

logger.defaultConsoleAppender = (name, level, args) ->
  # For those Console that don't have a real "level" link back to console.log
  console[level] = console.log unless console[level]
  Function.prototype.apply.call console[level], console, args

log = logger.consoleLogger 'raml-toolkit-logger'

# Set up commander
program = require 'commander'

program.version '0.0.1'
program.usage '[options] <raml-file or path-to-raml>'
program.option '-t, --template [template]', 'specify output template [node-express]', 'node-express'
program.option '-v, --verbose', 'set the verbose level of output'
program.option '-q, --quiet', 'silence commands'

program.on '--help', ->
  # Read help file and print its contents.
  fs = require 'fs'
  file = fs.readFileSync "#{__dirname}/help.txt", 'utf8'
  log.info file

program.parse process.argv


# Set up log level
if program.verbose
  log.setLevel logger.DEBUG

if program.quiet
  log.setLevel logger.OFF

# Run commands
log.info  'Let the RAML magic begin:'
log.debug '  - verbose is enabled'
log.info  "  - #{program.template} template"
