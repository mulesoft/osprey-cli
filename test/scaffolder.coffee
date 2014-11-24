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
      fileWriter.content.trim().should.eql [
        "express = require 'express'",
        "path = require 'path'",
        "osprey = require 'osprey'",
        "",
        "app = module.exports = express()",
        "",
        "app.use express.bodyParser()",
        "app.use express.methodOverride()",
        "app.use express.compress()",
        "app.use express.logger('dev')",
        "",
        "app.set 'port', process.env.PORT || 3000",
        "",
        "api = osprey.create '/hello', app,",
        "  ramlFile: path.join(__dirname, '/assets/raml/" + options.raml + "'),",
        "  logLevel: 'debug'  #  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all",
        "",
        "# Adding business logic to a valid RAML Resource",
        "# api.get '/examples/:exampleId', (req, res) ->",
        "#   res.send({ name: 'example' })",
        "",
        "unless module.parent",
        "  port = app.get('port')",
        "  app.listen port",
        '  console.log "listening on port #{port}"'
      ].join('\n').trim()

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
      fileWriter.content.trim().should.eql [
        "var express = require('express');",
        "var path = require('path');",
        "var osprey = require('osprey');",
        "",
        "var app = module.exports = express();",
        "",
        "app.use(express.bodyParser());",
        "app.use(express.methodOverride());",
        "app.use(express.compress());",
        "app.use(express.logger('dev'));",
        "",
        "app.set('port', process.env.PORT || 3000);",
        "",
        "api = osprey.create('/hello', app, {",
        "  ramlFile: path.join(__dirname, '/assets/raml/" + options.raml + "'),",
        "  logLevel: 'debug'  //  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all",
        "});",
        "",
        "// Adding business logic to a valid RAML Resource",
        "// api.get('/examples/:exampleId', function(req, res) {",
        "//   res.send({ name: 'example' });",
        "// });",
        "",
        "if (!module.parent) {",
        "  var port = app.get('port');",
        "  app.listen(port);",
        "  console.log('listening on port ' + port);",
        "}"
      ].join('\n').trim()

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
      fileWriter.content.should.eql [
        '{',
        '  "name": "demo",',
        '  "version": "0.0.1",',
        '  "private": true,',
        '  "dependencies": {',
        '    "express": "3.4.4",',
        '    "osprey": "0.1.1"',
        '  },',
        '  "devDependencies": {',
        '    "grunt": "~0.4.2",',
        '    "grunt-contrib-watch": "~0.5.3",',
        '    "grunt-contrib-copy": "~0.4.1",',
        '    "grunt-contrib-clean": "~0.5.0",',
        '    "grunt-mocha-test": "~0.8.1",',
        '    "mocha": "1.15.1",',
        '    "should": "2.1.1",',
        '    "grunt-express-server": "~0.4.13",',
        '    "load-grunt-tasks": "~0.2.1",',
        '    "supertest": "~0.8.2",',
        '    "grunt-contrib-jshint": "~0.8.0"',
        '  }',
        '}',
        ''
      ].join('\n')

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
      content.should.eql [
        "path = require 'path'",
        "",
        "module.exports = (grunt) ->",
        "  require('load-grunt-tasks') grunt",
        "",
        "  grunt.initConfig(",
        "    pkg: grunt.file.readJSON('package.json')",
        "",
        "    coffee:",
        "      compile:",
        "        expand: true",
        "        flatten: false",
        "        cwd: 'src'",
        "        src: ['**/*.coffee']",
        "        dest: './dist'",
        "        ext: '.js'",
        "",
        "    coffeelint:",
        "      app: ['src/**/*.coffee']",
        "      options:",
        "        max_line_length:",
        "          level: 'ignore'",
        "",
        "    express:",
        "      options:",
        "        cmd: 'coffee'",
        "        port: process.env.PORT || 3000",
        "        script: 'src/app.coffee'",
        "      development:",
        "        options:",
        "          node_env: 'development'",
        "      test:",
        "        options:",
        "          node_env: 'test'",
        "          port: 3001",
        "          ",
        "    watch:",
        "      express:",
        "        files: ['src/**/*.coffee', 'src/assets/raml/**/*.*']",
        "        tasks: ['coffeelint', 'express:development']",
        "        options:",
        "          spawn: false",
        "          atBegin: true",
        "  )",
        "",
        "  grunt.registerTask 'default', ['watch']"
      ].join('\n')

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

      content.should.eql [
        "var path = require('path');",
        "",
        "module.exports = function(grunt) {",
        "  grunt.initConfig({",
        "    pkg: grunt.file.readJSON('package.json'),",
        "    jshint: {",
        "      all: ['src/**/*.js']",
        "    },",
        "",
        "    express: {",
        "      options: {",
        "        port: process.env.PORT || 3000,",
        "        script: 'src/app.js'",
        "      },",
        "      development: {",
        "        options: {",
        "          node_env: 'development'",
        "        }",
        "      },",
        "      test: {",
        "        options: {",
        "          node_env: 'test',",
        "          port: 3001",
        "        }",
        "      }",
        "    },",
        "",
        "    watch: {",
        "      express: {",
        "        files: ['src/**/*.js', 'src/assets/raml/**/*.*'],",
        "        tasks: ['jshint', 'express:development'],",
        "        options: {",
        "          spawn: false,",
        "          atBegin: true",
        "        }",
        "      }",
        "    }",
        "  });",
        "",
        "  require('load-grunt-tasks')(grunt);",
        "",
        "  grunt.registerTask('default', ['watch']);",
        "};",
        ""
      ].join('\n')

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
