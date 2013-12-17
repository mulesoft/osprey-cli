module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    coffee:
      compile:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: './lib',
        ext: '.js'

    express:
      dev:
        options:
          script: 'lib/app.js'

    watch:
      development:
        files: ['src/**/*.coffee'],
        tasks: ['coffee'],
        options:
          atBegin: true
      express:
        files: ['lib/**/*.js'],
        tasks: ['express:dev:stop', 'express:dev'],
        options:
          atBegin: true,
          spawn: false
  )

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.registerTask 'default', ['watch']