gulp = require 'gulp'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
minify = require 'gulp-minify-css'
concat = require 'gulp-concat'
del = require 'del'
browserSync = require 'browser-sync'
reload = browserSync.reload

paths =
  npm: './node_modules'
  src: './src'
  output: './www'

gulp.task 'clean', (cb) ->
  del paths.output, cb

gulp.task 'index', ->
  gulp.src(paths.src + '/*.html')
  .pipe gulp.dest(paths.output)
  .pipe reload(stream: true)

gulp.task 'sass', ->
  gulp.src([
    paths.npm + '/normalize.css/normalize.css'
    paths.src + '/scss/*.scss'
  ])
  .pipe sass(errLogToConsole: true)
  .pipe autoprefixer()
  .pipe minify(keepSpecialComments: 0)
  .pipe concat('style.css')
  .pipe gulp.dest(paths.output + '/css')
  .pipe reload(stream: true)

gulp.task 'img', ->
  gulp.src(paths.src + '/img/**')
  .pipe gulp.dest(paths.output + '/img')
  .pipe reload(stream: true)

gulp.task 'browser-sync', ->
  browserSync
    open: false
    server:
      baseDir: paths.output

gulp.task 'default', ['index', 'sass', 'img', 'browser-sync'], ->
  gulp.watch paths.src + '/scss/**/*.scss', ['sass']
  gulp.watch paths.src + '/*.html', ['index']