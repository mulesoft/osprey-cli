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
        src: ['src/shebang.js', 'dist/raml-toolkit.js'],
        dest: 'dist/raml-toolkit.js'

    copy:
      templates:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'templates/**/*.swig',
        dest: 'dist/'
      examples:
        expand: true,
        flatten: false,
        cwd: 'src',
        src: 'examples/leagues/**/*.*',
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
        # cwd: '',
        src: 'LICENSE',
        dest: 'dist/'

    watch:
      development:
        files: ['src/**/*.coffee', 'test/**/*.coffee', 'scr/**/*.swig'],
        tasks: ['coffeelint', 'mochaTest'],
        options:
          atBegin: true
  )

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', ['clean:build', 'watch']
  grunt.registerTask 'release', ['clean:build', 'coffeelint', 'coffee', 'mochaTest', 'concat', 'copy']
