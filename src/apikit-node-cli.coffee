#!/usr/bin/env node

# Set up logger
logger = require 'simply-log'

logger.defaultConsoleAppender = (name, level, args) ->
  # For those Console that don't have a real "level" link back to console.log
  console[level] = console.log unless console[level]
  Function.prototype.apply.call console[level], console, args

log = logger.consoleLogger 'apikit-node'
log.setLevel logger.WARN

# Load file system
fs = require 'fs.extra'
path = require 'path'

# Set up commander
program = require 'commander'
config = require '../package.json'

program.version config.version
program.usage '[options] <raml-file or path-to-raml>'
program.option '-b, --baseUri [uri]', 'specify base URI for your API', '/api'
program.option '-l, --language [language]', 'specify output programming language: javascript, coffeescript', 'javascript'
program.option '-t, --target [directory]', 'specify output directory'
program.option '-n, --name [app-name]', 'specify application name', 'raml-app'
program.option '-v, --verbose', 'set the verbose level of output'
program.option '-q, --quiet', 'silence commands'

program.on '--help', ->
  # Read help file and print its contents.
  file = fs.readFileSync "#{__dirname}/assets/help.txt", 'utf8'
  log.info file

# Set common help recommendation message
helpTip = '\nUse -h or --help for more information.'

# Parse input arguments
program.parse process.argv

# Set up log level
if program.verbose
  log.setLevel logger.DEBUG
  log.debug "Running #{config.name} #{config.version}\n"

if program.quiet
  log.setLevel logger.OFF

# Log runtime parameters
log.info  'Runtime parameters'
log.info  "  - baseUri: #{program.baseUri}"
log.info  "  - language: #{program.language}"
log.info  "  - target: #{program.target}" if program.target
log.info  "  - name: #{program.name}"
log.info  "  - args: #{program.args}" if program.args.length > 0
log.info  " "


# Validate baseUri
unless program.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)
  log.error "ERROR - Invalid base URI: #{program.baseUri}"
  log.error helpTip
  return 1


# Validate language valid value
unless program.language in ['javascript', 'coffeescript']
  log.error "ERROR - Invalid output language type: #{program.language}"
  log.error helpTip
  return 1


# Validate target folder
unless program.target
  program.target = 'output'
  log.warn "WARNING - No target directory was provided. Setting target directory to: #{program.target}"


# Create target directory if needed
try
  unless fs.existsSync program.target
    log.debug "Creating directory: #{program.target}"
    fs.mkdirSync program.target
catch e
  log.error "ERROR - Unable to create target directory #{progam.target}"
  log.error helpTip
  return 1

folderStats = fs.lstatSync program.target
unless folderStats.isDirectory
  log.error "ERROR - Invalid target directory #{progam.target}"
  log.error helpTip
  return 1


# Create resources folder
resourcePath = path.join program.target, 'resources'

unless fs.existsSync resourcePath
  log.debug "Creating resource directory: #{resourcePath}"
  fs.mkdirSync resourcePath


# Validate RAML parameter
if program.args.length is 0
  log.warn "WARNING - No RAML file was provided. A sample RAML file will be used instead."
  ramlFile = null
else
  ramlFile = program.args[0]

if program.args.length > 1
  log.error "ERROR - Invalid set of parameters."
  log.error helpTip
  return 1


# Parse RAML
Scaffolder = require './scaffolder'

scaffolder = new Scaffolder log, fs
scaffolder.generate program
