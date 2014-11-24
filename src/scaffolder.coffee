# parser = require './wrapper'
swig  = require 'swig'
lingo = require 'lingo'
path = require 'path'

class Scaffolder
  constructor: (@logger, @fileWriter) ->
    logger.setLevel 'info'

  generate: (options) =>
    @logger.debug '[Scaffolder] - Starting scaffolder'

    fileType = if options.language == 'javascript' then 'js' else 'coffee'

    @createApp options, fileType
    @createGruntfile options, fileType
    @createPackage options
    @copyRaml options

  createApp: (options, fileType) =>
    @logger.debug "[Scaffolder] - Generating app.#{ fileType }"

    templatePath = path.join __dirname, 'templates', options.language, 'app.swig'

    params =
      apiPath: options.baseUri
      ramlFileName: if options.raml then path.basename(options.raml) else 'api.raml'

    @write path.join(options.target, "src/app.#{ fileType }"), @render(templatePath, params)

  createPackage: (options) =>
    @logger.debug "[Scaffolder] - Generating Package.json"

    templatePath = path.join __dirname, 'templates', options.language, 'package.swig'

    params =
      appName: options.name

    @write path.join(options.target, 'package.json'), @render(templatePath, params)

  createGruntfile: (options, fileType) =>
    src = path.join __dirname, 'templates', options.language, 'Gruntfile.swig'
    target = path.join options.target , "Gruntfile.#{ fileType }"

    @fileWriter.copy src, target, (err) =>
      @logger.debug "[Scaffolder] - Generating Gruntfile"

  copyRaml: (options) =>
    @logger.debug "[Scaffolder] - Generating RAML file"

    unless options.raml
      templatePath = path.join __dirname, 'templates/common/raml.swig'

      params =
        appName: options.name

      @write path.join(options.target, 'src/assets/raml/api.raml'), @render(templatePath, params)
    else
      source = options.raml
      dest = path.join options.target, 'src/assets/raml'

      if @fileWriter.lstatSync(source).isDirectory()
        @fileWriter.copyRecursive source, dest, (err) ->
      else
        dest = path.join dest, path.basename(source)
        @fileWriter.copy source, dest, (err) ->

  render: (templatePath, params) ->
    swig.renderFile templatePath, params

  write: (path, data) =>
    try
      @fileWriter.writeFile path, data
    catch e
      @logger.debug "[Scaffolder] - #{ e.message }"

module.exports = Scaffolder
