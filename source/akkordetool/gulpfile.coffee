gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'

coffee = require 'gulp-coffee'
cson = require 'gulp-cson'
uglify = require 'gulp-uglify'

gulp.task 'clean', (cb) ->
  #del(['../../build/akkordetool/**/*'], cb)
  cb()

gulp.task 'cson', ->
  gulp.src 'src/*.cson'
  .pipe cson()
  .pipe gulp.dest '../../build/akkordetool'

gulp.task 'coffee', (cb) ->
  gulp.src 'src/*.coffee'
  .pipe coffee()
  .pipe uglify()
  .pipe gulp.dest '../../build/akkordetool'

  cb()

gulp.task 'img', ->
  gulp.src 'src/img/**/*'
  .pipe gulp.dest '../../build/akkordetool/img'

#build the presentation and minify it
gulp.task 'build', ['clean'], (cb) ->
  runSequence 'clean', ['coffee', 'img', 'cson'], cb

gulp.task 'default', ['build']
