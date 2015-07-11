gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'
browserSync = require('browser-sync').create()
fm = require 'html-frontmatter'
hamlc = require 'haml-coffee'
fs = require 'fs'
glob = require 'glob'

gutil = require 'gulp-util'
file = require 'gulp-file'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
cson = require 'gulp-cson'
uglify = require 'gulp-uglify'
minifyCSS = require 'gulp-minify-css'
minifyHTML = require 'gulp-minify-html'

helpers = {}
helpers.color = require './helpers/colorHelper'
helpers.structure = require './helpers/structureHelper'
helpers.miniMenu = require './helpers/miniMenuHelper'

config =
  production: true

gulp.task 'setDevEnv', (cb) ->
  config.production = false
  cb()

gulp.task 'clean', (cb) ->
  del(['build/**/*'], cb)

gulp.task 'html', (cb) ->
  fs.readFile 'source/layout.hamlc', 'utf8', (err, layout) ->
    throw err if err?

    glob 'source/**/*.html', (err, filenames) ->
      throw err if err?

      for filename in filenames
        template = fs.readFileSync filename, 'utf8'

        frontmatter = fm template

        html = hamlc.compile(layout, escapeHtml: false)(
          helpers: helpers, data: frontmatter, content: template)

        file filename.replace(/^source\//, ''), html, src: true
          .pipe if config.production then minifyHTML() else gutil.noop()
          .pipe gulp.dest 'build'

      browserSync.reload()
      cb()

gulp.task 'sass', ->
  gulp.src ['source/stylesheets/main.scss',
  'source/stylesheets/additional/*.scss']
    .pipe sass()
    .pipe if config.production then minifyCSS() else gutil.noop()
    .pipe gulp.dest 'build/stylesheets'
    .pipe browserSync.stream match: '**/*.css'

gulp.task 'assets', (cb) ->
  gulp.src 'source/img/**/*'
      .pipe gulp.dest 'build/img'

  gulp.src 'source/midi/**/*'
    .pipe gulp.dest 'build/midi'

  gulp.src 'source/mp3/**/*'
    .pipe gulp.dest 'build/mp3'

  gulp.src 'source/pdf/**/*'
    .pipe gulp.dest 'build/pdf'

gulp.task 'akkordetool', (cb) ->
  gulp.src 'source/akkordetool/data.cson'
    .pipe cson()
    .pipe gulp.dest 'build/akkordetool'

  gulp.src 'source/akkordetool/index.coffee'
    .pipe coffee()
    .pipe uglify()
    .pipe gulp.dest 'build/akkordetool'

  gulp.src 'source/img/gtak'
    .pipe gulp.dest 'build/akkordetool/img'

  browserSync.reload()

  cb()

gulp.task 'build', (cb) ->
  runSequence 'clean', ['sass', 'assets', 'html', 'akkordetool'], cb

# build without minifying, watch for file changes
# and set up a dev server with live-reloading
gulp.task 'dev', ['setDevEnv', 'build'], ->
  browserSync.init server: './build'

  gulp.watch ['source/**/*.html', 'source/**/*.hamlc'], ['html']
  gulp.watch 'source/stylesheets/**/*', ['sass']
  gulp.watch 'source/akkordetool/**/*', ['akkordetool']

gulp.task 'default', ['dev']
