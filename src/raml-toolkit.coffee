#!/usr/bin/env node

# Set up logger
logger = require 'simply-log'

logger.defaultConsoleAppender = (name, level, args) ->
  # For those Console that don't have a real "level" link back to console.log
  console[level] = console.log unless console[level]
  Function.prototype.apply.call console[level], console, args

log = logger.consoleLogger 'raml-toolkit'

# Load file system
fs = require 'fs'
path = require 'path'

# Set up commander
program = require 'commander'
config = require '../package.json'

program.version config.version
program.usage '[options] <raml-file or path-to-raml>'
program.option '-t, --template [template]', 'specify output template [node-express]', 'templates/node/express'
program.option '-T, --target [directory]', 'specify output directory', '.'
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
log.info  'Let the RAML magic begin:'
log.debug '  - verbose: enabled'
log.info  "  - template: #{program.template}"
log.info  "  - target: #{program.target}"
log.debug "  - args: #{program.args}"
log.debug " "

# Validate template folder
templateFolder = "#{__dirname}/#{program.template.replace /-/, '/'}"
log.debug "Template folder: #{templateFolder}"

try
  folderStats = fs.lstatSync templateFolder
  throw new Error unless folderStats.isDirectory
catch e
  log.debug "Template does not exist or is not a directory."
  log.error "Error: Invalid template name."


# Validate target folder
log.debug "Target folder: #{program.target}"

# Create target folder if not exists
unless fs.existsSync program.target
  fs.mkdirSync program.target

# Create resources folder
resourcePath = path.join program.target, 'resources'

unless fs.existsSync resourcePath
  fs.mkdirSync resourcePath

# Validate RAML parameter
throw new Error "Error: Missing RAML parameter." if program.args.length is 0
throw new Error "Error: Invalid RAML parameter." if program.args.length isnt 1
ramlFile = program.args[0]


# Parse RAML
parser = require './toolkit-parser'
Scaffolder = require './scaffolder'

parser.loadRaml ramlFile, log, (toolkitParser) ->
  scaffolder = new Scaffolder program.template, log, fs
  scaffolder.generate toolkitParser.getResourcesList(), program.target