module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    coffee:
      compile:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: './dist',
        ext: '.js'

    express:
      dev:
        options:
          script: 'dist/app.js'

    copy:
      assets:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'assets/**/*.*',
        dest: 'dist/'

    watch:
      assets:
        files: ['src/assets/**/*.*'],
        tasks: ['copy:assets'],
        options:
          atBegin: true
      development:
        files: ['src/**/*.coffee'],
        tasks: ['coffee'],
        options:
          atBegin: true
      express:
        files: ['dist/**/*.js'],
        tasks: ['express:dev:stop', 'express:dev'],
        options:
          atBegin: true,
          spawn: false
  )

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', ['watch']
