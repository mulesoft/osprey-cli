#!/usr/bin/env node

fs = require 'fs.extra'
path = require 'path'
argParse = require 'argparse'
config = require '../package.json'
Scaffolder = require './scaffolder'
ramlParser = require 'raml-parser'
Table = require 'cli-table'
logger = require './utils/logger'

ArgumentParser = argParse.ArgumentParser

helpTip = fs.readFileSync('./src/assets/help.txt').toString()

parser = new ArgumentParser
  version: config.version,
  description: 'Osprey Node CLI'

subparsers = parser.addSubparsers
  title:'subcommands',
  dest:"command"

newParser = subparsers.addParser 'new'

newParser.addArgument(
  ['raml'],
  nargs: '?',
  help: 'A RAML file path or the path to container folder'
)

newParser.addArgument(
  [ '-b', '--baseUri' ],
  help: 'Specify base URI for your API'
  defaultValue: '/api'
  metavar: ''
)

newParser.addArgument(
  [ '-l', '--language' ],
  help: 'Specify output programming language: javascript, coffeescript',
  choices: ['javascript', 'coffeescript']
  defaultValue: 'javascript',
  metavar: ''
)

newParser.addArgument(
  [ '-t', '--target' ],
  help: 'Specify output directory',
  metavar: ''
)

newParser.addArgument(
  [ '-n', '--name' ],
  help: 'Specify application name',
  defaultValue: 'raml-app',
  metavar: ''
)

newParser.addArgument(
  [ '-v', '--verbose' ],
  help: 'Set the verbose level of output',
  action: 'storeTrue'
  metavar: ''
)

newParser.addArgument(
  [ '-q', '--quiet' ],
  action: 'storeTrue'
  help: 'Silence commands',
  metavar: ''
)

listParser = subparsers.addParser 'list'

listParser.addArgument(
  [ 'raml' ],
  help: 'A RAML file path or the path to container folder'
)

# Parse input arguments
options = parser.parseArgs()

logger.setLevel 'info'

if options.command == 'new'
  # Set up log level
  if options.verbose
    #log.setLevel logger.DEBUG
    logger.info "Running #{config.name} #{config.version}\n"
  if options.quiet
    logger.setLevel 'off'
  # Log runtime parameters
  logger.info "Runtime parameters"
  logger.info "  - baseUri: #{options.baseUri}"
  logger.info "  - language: #{options.language}"
  logger.info "  - target: #{options.target}"
  logger.info "  - name: #{options.name}"
  logger.info "  - raml: #{options.raml}"
  logger.info " "

  # Validate baseUri
  unless options.baseUri.match(/^\/[A-Z0-9._%+-\/]+$/i)
    logger.error "ERROR - Invalid base URI: #{options.baseUri}"
    logger.error helpTip
    return 1

  # Remove initial slash
  options.baseUri = options.baseUri.replace(/^\//g, '')

  # Validate target folder
  unless options.target
    options.target = 'output'
    logger.warn "WARNING - No target directory was provided. Setting target directory to: #{options.target}"

  # Clean up output folder
  if fs.existsSync options.target
    try
      fs.rmrfSync options.target, (err) ->
        logger.debug 'Target folder was clean up'
    catch e
      logger.error helpTip
      return 1

  # Create target directory if needed
  try
    logger.debug "Creating directory: #{options.target}"
    fs.mkdirSync options.target
  catch e
    logger.error "ERROR - Unable to create target directory #{progam.target}"
    logger.error helpTip
    return 1

  folderStats = fs.lstatSync options.target
  unless folderStats.isDirectory
    logger.error "ERROR - Invalid target directory #{progam.target}"
    logger.error helpTip
    return 1

  # TOOO: Refactor this thing!
  # Create base structure
  logger.debug "Creating src directory"
  fs.mkdirSync path.join(options.target, 'src')

  logger.debug "Creating assets directory"
  fs.mkdirSync path.join(options.target, 'src/assets')
  fs.mkdirSync path.join(options.target, 'src/assets/raml')

  logger.debug "Creating test directory"
  fs.mkdirSync path.join(options.target, 'test')

  #Validate RAML parameter
  unless options.raml
    logger.warn "WARNING - No RAML file was provided. A sample RAML file will be used instead."

  # Parse RAML
  scaffolder = new Scaffolder logger, fs
  scaffolder.generate options
else if options.command == 'list'
  table = new Table
    colWidths: [15, 100],
    chars: { 'top': '' , 'top-mid': '' , 'top-left': '' , 'top-right': ''
             , 'bottom': '' , 'bottom-mid': '' , 'bottom-left': '' , 'bottom-right': ''
             , 'left': '' , 'left-mid': '' , 'mid': '' , 'mid-mid': ''
             , 'right': '' , 'right-mid': '' , 'middle': ' ' },
    style: { 'padding-left': 0, 'padding-right': 0 }

  resourceReader = (resources, resourceUri) ->
    if !!resources
      resources.forEach (resource) ->
        relativeUri = resourceUri + resource.relativeUri

        resource.methods?.forEach (method) ->
          table.push [method.method.toUpperCase(), relativeUri]

        if !!resource.resources
          resourceReader resource.resources, relativeUri

  ramlParser.loadFile(options.raml).then((data) ->
    resourceReader data.resources, ''
    console.log table.toString()
  , (error) ->
    logger.error 'Error parsing: ' + error
  )