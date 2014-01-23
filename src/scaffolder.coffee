parser = require './wrapper'
swig  = require 'swig'
lingo = require 'lingo'
path = require 'path'

class Scaffolder
  constructor: (@logger, @fileWriter) ->

  generate: (options) =>
    @logger.debug '[Scaffolder] - Starting scaffolder'

    fileType = if options.language == 'javascript' then 'js' else 'coffee'

    @createApp options, fileType
    @createGruntfile options, fileType
    @createPackage options
    @copyAssets options
    @copyRaml options

  createApp: (options, fileType) =>
    @logger.debug "[Scaffolder] - Generating app.#{ fileType }"

    templatePath = path.join __dirname, 'templates', options.language, 'app.swig'

    params =
      apiPath: options.baseUri

    @write path.join(options.target, "src/app.#{ fileType }"), @render(templatePath, params)

  createPackage: (options) =>
    @logger.debug "[Scaffolder] - Generating Package.json"

    templatePath = path.join __dirname, 'templates/common/package.swig'

    params =
      appName: options.name

    @write path.join(options.target, 'package.json'), @render(templatePath, params)

  createGruntfile: (options, fileType) =>
    src = path.join __dirname, 'templates', options.language, 'Gruntfile.swig'
    target = path.join options.target , "Gruntfile.#{ fileType }"

    @fileWriter.copy src, target, (err) =>
      @logger.debug "[Scaffolder] - Generating Gruntfile"

  copyAssets: (options) =>
    source = path.join __dirname, 'assets', 'console'
    dest = path.join options.target, 'src/assets/console'
    templatePath = path.join __dirname, 'templates/common/index.swig'

    params =
      apiPath: options.baseUri

    @fileWriter.copyRecursive source, dest, (err) =>
      @logger.debug "[Scaffolder] - Generating Assets"
      @write path.join(options.target, 'src/assets/console/index.html'), @render(templatePath, params)

  copyRaml: (options) =>
    @logger.debug "[Scaffolder] - Generating RAML file"

    if options.args.length is 0
      templatePath = path.join __dirname, 'templates/common/raml.swig'

      params =
        appName: options.name

      @write path.join(options.target, 'src/assets/raml/api.raml'), @render(templatePath, params)
    else
      source = options.args[0]
      dest = path.join options.target, 'src/assets/raml'
      
      @fileWriter.copyRecursive source, dest, (err) ->

  render: (templatePath, params) ->
    swig.renderFile templatePath, params

  write: (path, data) =>
    try
      @fileWriter.writeFile path, data
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

module.exports = Scaffolder
