module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    coffee:
      compile:
        expand: true,
        flatten: false,
        src: ['**/*.coffee'],
        dest: './lib',
        ext: '.js'
  )

  grunt.loadNpmTasks('grunt-contrib-coffee')