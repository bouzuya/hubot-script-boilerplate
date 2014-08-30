gulp = require 'gulp'
gutil = require 'gulp-util'

paths =
  src: './src/**/*.coffee'
  test: './test/**/*.coffee'
  testFixtures: './test/*.png'
  coverage: './coverage/**/lcov.info'
  coverageDir: './coverage/'
  compiledDir: './.tmp/'
  compiledSrc: './.tmp/src/**/*.js'
  compiledSrcDir: './.tmp/src/'
  compiledTest: './.tmp/test/**/*.js'
  compiledTestDir: './.tmp/test/'
  buildDir: './lib/'

gulp.task 'clean', (done) ->
  del = require 'del'
  del [
    paths.compiledDir
    paths.coverageDir
    paths.buildDir
  ], done

gulp.task 'coveralls', ->
  coveralls = require 'gulp-coveralls'
  gulp
    .src paths.coverage
    .pipe coveralls()

gulp.task 'build', ->
  coffee = require 'gulp-coffee'
  gulp
    .src paths.src
    .pipe coffee(bare: true).on('error', gutil.log)
    .pipe gulp.dest(paths.buildDir)

gulp.task 'compile-src', ->
  coffee = require 'gulp-coffee'
  gulp
    .src paths.src
    .pipe coffee(bare: true).on('error', gutil.log)
    .pipe gulp.dest(paths.compiledSrcDir)

gulp.task 'copy-test-fixtures', ->
  gulp
    .src paths.testFixtures
    .pipe gulp.dest(paths.compiledTestDir)

gulp.task 'compile-test', ['copy-test-fixtures'], ->
  coffee = require 'gulp-coffee'
  espower = require 'gulp-espower'
  gulp
    .src paths.test
    .pipe coffee(bare: true).on('error', gutil.log)
    .pipe espower()
    .pipe gulp.dest(paths.compiledTestDir)

gulp.task 'test', ['compile-src', 'compile-test'], ->
  istanbul = require 'gulp-istanbul'
  mocha = require 'gulp-mocha'
  gulp
    .src paths.compiledSrc
    .pipe istanbul()
    .on 'finish', ->
      gulp
        .src paths.compiledTest
        .pipe mocha().on('error', gutil.log)
        .pipe istanbul.writeReports(paths.coverageDir)

gulp.task 'watch', ->
  gulp.watch [paths.src, paths.test], ['test']

gulp.task 'default', ['build']
