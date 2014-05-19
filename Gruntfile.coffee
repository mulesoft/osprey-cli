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
      app: ['src/**/*.coffee'],
      options:
        max_line_length:
          level: 'ignore'

    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script'
        src: ['test/**/*.coffee']

    clean:
      build: ['dist']

    concat:
      dist:
        src: ['src/assets/shebang.js', 'dist/osprey-cli.js'],
        dest: 'dist/osprey-cli.js'

    copy:
      templates:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'templates/**/*.*',
        dest: 'dist/'
      assets:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'assets/**/*.*',
        dest: 'dist/'
      license:
        expand: true,
        flatten: false,
        src: 'LICENSE',
        dest: 'dist/'

    watch:
      development:
        files: ['src/**/*.coffee', 'test/**/*.coffee', 'scr/**/*.swig'],
        tasks: ['coffeelint', 'mochaTest'],
        options:
          atBegin: true
  )

  require('load-grunt-tasks') grunt

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'release', ['clean:build', 'coffeelint', 'copy', 'coffee', 'mochaTest', 'concat']
  grunt.registerTask 'test', ['mochaTest']

