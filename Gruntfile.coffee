module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),

    coffee:
      compile:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'dist/',
        ext: '.js'

    coffeelint:
      app: ['src/**/*.coffee']

    clean:
      build: ['dist']

    copy:
      templates:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'templates/**/*.swig',
        dest: 'dist/'

    watch:
      coffee:
        files: ['src/**/*.coffee'],
        tasks: ['coffeelint', 'coffee'],
        options:
          atBegin: true
      swig:
        files: ['src/**/*.swig'],
        tasks: ['copy:templates'],
        options:
          atBegin: true
  )

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask('default', ['clean:build', 'watch'])