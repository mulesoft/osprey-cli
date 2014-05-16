Scaffolder = require '../src/scaffolder'
should = require 'should'
logger = require '../src/utils/logger'
ramlParser = require 'raml-parser'
path = require 'path'

describe 'TOOLKIT SCAFFOLDER', ->
  describe 'SCAFFOLDER READ RAML RESOURCES', ->

  describe 'SCAFFOLDER GENERATION', ->
    it 'Should correctly generate app.coffee', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
        copy: (src, target)->
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'coffeescript'
      options.target = './target'
      options.name = 'demo'
      options.raml = 'hello.raml'

      scaffolder.createApp options, "coffee"

      # Assert
      fileWriter.target.should.eql 'target/src/app.coffee'
      fileWriter.content.should.eql "express = require 'express'\npath = require 'path'\nosprey = require 'osprey'\n\napp = module.exports = express()\n\napp.use express.bodyParser()\napp.use express.methodOverride()\napp.use express.compress()\napp.use express.logger('dev')\n\napp.set 'port', process.env.PORT || 3000\n\napi = osprey.create '/"  + options.baseUri + "', app,\n  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),\n  logLevel: 'debug'  #  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all\n\n# Adding business logic to a valid RAML Resource\n# api.get '/examples/:exampleId', (req, res) ->\n#   res.send({ name: 'example' })\n\nunless module.parent\n  port = app.get('port')\n  app.listen port\n  console.log \"listening on port \#{port}\""
      done()

     it 'Should correctly generate app.js', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
        copy: (src, target)->
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'javascript'
      options.target = './target'
      options.name = 'demo'
      options.raml = 'hello.raml'

      scaffolder.createApp options, "coffee"

      # Assert
      fileWriter.target.should.eql 'target/src/app.coffee'
      fileWriter.content.should.eql "var express = require('express');\nvar path = require('path');\nvar osprey = require('osprey');\n\nvar app = module.exports = express();\n\napp.use(express.bodyParser());\napp.use(express.methodOverride());\napp.use(express.compress());\napp.use(express.logger('dev'));\n\napp.set('port', process.env.PORT || 3000);\n\napi = osprey.create('/hello', app, {\n  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),\n  logLevel: 'debug'  //  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all\n});\n\n// Adding business logic to a valid RAML Resource\n// api.get('/examples/:exampleId', function(req, res) {\n//   res.send({ name: 'example' });\n// });\n\nif (!module.parent) {\n  var port = app.get('port');\n  app.listen(port);\n  console.log('listening on port ' + port);\n}"
      done()

     it 'Should correctly generate package file', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
        copy: (src, target)->
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'javascript'
      options.target = './target'
      options.name = 'demo'
      options.raml = 'hello.raml'

      scaffolder.createPackage options

      # Assert
      fileWriter.target.should.eql 'target/package.json'
      fileWriter.content.should.eql "{\n  \"name\": \"demo\",\n  \"version\": \"0.0.1\",\n  \"private\": true,\n  \"dependencies\": {\n    \"express\": \"3.4.4\",\n    \"osprey\": \"0.1.1\"\n  },\n  \"devDependencies\": {\n    \"grunt\": \"~0.4.2\",\n    \"grunt-contrib-watch\": \"~0.5.3\",\n    \"grunt-contrib-copy\": \"~0.4.1\",\n    \"grunt-contrib-clean\": \"~0.5.0\",\n    \"grunt-mocha-test\": \"~0.8.1\",\n    \"mocha\": \"1.15.1\",\n    \"should\": \"2.1.1\",\n    \"grunt-express-server\": \"~0.4.13\",\n    \"load-grunt-tasks\": \"~0.2.1\",\n    \"supertest\": \"~0.8.2\",\n    \"grunt-contrib-jshint\": \"~0.8.0\"\n  }\n}\n"
      done()

    it 'Should correctly generate Gruntfile.coffee', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) ->
        copy: (location,target)=>
          @target = target
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'coffeescript'
      options.target = './target'
      options.name = 'demo'
      options.raml = 'hello.raml'

      scaffolder.createGruntfile options, 'coffee'

      templatePath = path.join __dirname, '../src/templates', options.language, 'Gruntfile.swig'

      params =
        appName: options.name

      content = scaffolder.render templatePath, params

      # Assert
      fileWriter.target.should.eql 'target/Gruntfile.coffee'
      content.should.eql "path = require 'path'\n\nmodule.exports = (grunt) ->\n  require('load-grunt-tasks') grunt\n\n  grunt.initConfig(\n    pkg: grunt.file.readJSON('package.json')\n\n    coffee:\n      compile:\n        expand: true\n        flatten: false\n        cwd: 'src'\n        src: ['**/*.coffee']\n        dest: './dist'\n        ext: '.js'\n\n    coffeelint:\n      app: ['src/**/*.coffee']\n      options:\n        max_line_length:\n          level: 'ignore'\n\n    express:\n      options:\n        cmd: 'coffee'\n        port: process.env.PORT || 3000\n        script: 'src/app.coffee'\n      development:\n        options:\n          node_env: 'development'\n      test:\n        options:\n          node_env: 'test'\n          port: 3001\n          \n    watch:\n      express:\n        files: ['src/**/*.coffee', 'src/assets/raml/**/*.*']\n        tasks: ['coffeelint', 'express:development']\n        options:\n          spawn: false\n          atBegin: true\n  )\n\n  grunt.registerTask 'default', ['watch']"
      done()

    it 'Should correctly generate Gruntfile.js', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) ->
        copy: (location,target)=>
          @target = target
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'javascript'
      options.target = './target'
      options.name = 'demo'
      options.raml = 'hello.raml'

      scaffolder.createGruntfile options, 'js'

      templatePath = path.join __dirname, '../src/templates', options.language, 'Gruntfile.swig'

      params =
        appName: options.name

      content = scaffolder.render templatePath, params

      # Assert
      fileWriter.target.should.eql 'target/Gruntfile.js'
      content.should.eql "var path = require('path');\n\nmodule.exports = function(grunt) {\n  grunt.initConfig({\n    pkg: grunt.file.readJSON('package.json'),\n    jshint: {\n      all: ['src/**/*.js']\n    },\n\n    express: {\n      options: {\n        port: process.env.PORT || 3000,\n        script: 'src/app.js'\n      },\n      development: {\n        options: {\n          node_env: 'development'\n        }\n      },\n      test: {\n        options: {\n          node_env: 'test',\n          port: 3001\n        }\n      }\n    },\n\n    watch: {\n      express: {\n        files: ['src/**/*.js', 'src/assets/raml/**/*.*'],\n        tasks: ['jshint', 'express:development'],\n        options: {\n          spawn: false,\n          atBegin: true\n        }\n      }\n    }\n  });\n\n  require('load-grunt-tasks')(grunt);\n\n  grunt.registerTask('default', ['watch']);\n};\n"
      done()
    it 'Should correctly generate default raml file having the correct name inside', (done) ->
      # Arrange
      fileWriter = new (class FileWriter
        writeFile:  (target, content) =>
          @target = target
          @content = content
        copy: (src, target)->
        lstatSync: (src)->
          return new (class directory
            isDirectory:()->
              return true
            )
        copyRecursive: ()->
      )

      scaffolder = new Scaffolder logger, fileWriter

      # Act
      options = new Object()
      options.baseUri = 'hello'
      options.language = 'javascript'
      options.target = './target'
      options.name = 'demo'

      scaffolder.copyRaml options

      # Assert
      fileWriter.target.should.eql 'target/src/assets/raml/api.raml'
      fileWriter.content.should.eql "#%RAML 0.8\n---\ntitle: \"demo\""
      done()
