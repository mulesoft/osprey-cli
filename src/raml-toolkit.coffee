#!/usr/bin/env node

# Set up logger
logger = require 'simply-log'

logger.defaultConsoleAppender = (name, level, args) ->
  # For those Console that don't have a real "level" link back to console.log
  console[level] = console.log unless console[level]
  Function.prototype.apply.call console[level], console, args

log = logger.consoleLogger 'raml-toolkit'
log.setLevel logger.WARN

# Load file system
fs = require 'fs'
path = require 'path'

# Set up commander
program = require 'commander'
config = require '../package.json'

program.version config.version
program.usage '[options] <raml-file or path-to-raml>'
program.option '-b, --baseUri [uri]', 'specify base URI for your API', '/api'
program.option '-l, --language [language]', 'specify output programming language: javascript, coffescript', 'javascript'
program.option '-t, --target [directory]', 'specify output directory'
program.option '-v, --verbose', 'set the verbose level of output'
program.option '-q, --quiet', 'silence commands'

program.on '--help', ->
  # Read help file and print its contents.
  file = fs.readFileSync "#{__dirname}/assets/help.txt", 'utf8'
  log.info file

program.parse process.argv

# Set up log level
if program.verbose
  log.setLevel logger.DEBUG

if program.quiet
  log.setLevel logger.OFF

# Run commands
log.info  'Runtime parameters'
log.debug '  - verbose: enabled'
log.info  "  - baseUri: #{program.baseUri}"
log.info  "  - language: #{program.language}"
log.info  "  - target: #{program.target}"
log.info  "  - args: #{program.args}"
log.info  " "

# Validate baseUri
unless program.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)
  log.error "Error: Invalid base URI argument: #{program.baseUri}"
  return 1


# Validate language valid value
unless program.language in ['javascript', 'coffescript']
  log.error "Error: Invalid output language type argument: #{program.output}"
  return 1


# Validate target folder
unless program.target
  log.debug "Setting target directory to #{program.target}"
  program.target = 'output'

# Create target directory if needed
try
  unless fs.existsSync program.target
    log.debug "Creating directory: #{program.target}"
    fs.mkdirSync program.target
catch e
  log.error "Error: Unable to create target directory #{progam.target}"
  return 1

folderStats = fs.lstatSync program.target
unless folderStats.isDirectory
  log.error "Error: Invalid target directory #{progam.target}"
  return 1


# Create resources folder
resourcePath = path.join program.target, 'resources'

unless fs.existsSync resourcePath
  log.debug "Creating resource directory: #{resourcePath}"
  fs.mkdirSync resourcePath


# Validate RAML parameter
log.debug "Validate RAML file"
if program.args.length is 0
  log.warn "Warning: No RAML file was provided. A sample RAML file will be used instead."
  ramlFile = null
else
  ramlFile = program.args[0]

if program.args.length > 1
  log.error "Error: Invalid set of parameters."
  return 1


# Parse RAML
parser = require './parser-wrapper'
Scaffolder = require './scaffolder'

parser.loadRaml ramlFile, log, (wrapper) ->
  scaffolder = new Scaffolder program.template, log, fs
  scaffolder.generate wrapper.getResourcesList(), program.target
