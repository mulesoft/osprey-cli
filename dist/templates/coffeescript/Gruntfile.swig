path = require 'path'

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt

  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee']
        dest: './dist'
        ext: '.js'

    coffeelint:
      app: ['src/**/*.coffee']
      options:
        max_line_length:
          level: 'ignore'

    express:
      options:
        cmd: 'coffee'
        port: process.env.PORT || 3000
        script: 'src/app.coffee'
      development:
        options:
          node_env: 'development'
      test:
        options:
          node_env: 'test'
          port: 3001
          
    watch:
      express:
        files: ['src/**/*.coffee', 'src/assets/raml/**/*.*']
        tasks: ['coffeelint', 'express:development']
        options:
          spawn: false
          atBegin: true
  )

  grunt.registerTask 'default', ['watch']