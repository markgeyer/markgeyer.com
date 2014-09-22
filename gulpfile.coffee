gulp = require 'gulp'
fs = require 'fs'
minifycss = require 'gulp-minify-css'
autoprefixer = require 'gulp-autoprefixer'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
browserSync = require 'browser-sync'
rimraf = require 'gulp-rimraf'

path =
  sass: './src/sass/*.scss'
  css:  './www/css'
  srcIMG: './src/img/*'
  img:  './www/img'
  srcJS:  './src/js/**/*.js'
  js:  './www/js'
  srcHTML: './src/*.html'
  www: './www'

gulp.task 'init', ->
  fs.mkdirSync path.www unless fs.existsSync(path.www)
  fs.mkdirSync path.css unless fs.existsSync(path.css)
  fs.mkdirSync path.js unless fs.existsSync(path.js)
  gulp.src(path.srcIMG).pipe gulp.dest(path.img)

gulp.task 'clean', ->
  gulp.src(path.www, read: false)
  .pipe rimraf()

gulp.task 'html', ->
  gulp.src(path.srcHTML)
  .pipe gulp.dest(path.www)
  .pipe browserSync.reload(stream: true)

gulp.task 'sass', ->
  gulp.src([
    './node_modules/normalize.css/normalize.css'
    './src/sass/*.scss'
  ])
  .pipe sass()
  .pipe autoprefixer('last 1 version', '> 1%', 'ie 10', 'iOS 7', 'Android 4', cascade: true)
  .pipe concat('style.css')
  .pipe minifycss()
  .pipe gulp.dest(path.css)
  .pipe browserSync.reload(stream: true)

gulp.task 'img', ->
  gulp.src(path.srcIMG)
  .pipe gulp.dest(path.img)
  .pipe browserSync.reload(stream: true)

gulp.task 'browser-sync', ->
  browserSync.init null,
    server:
      baseDir: path.www

gulp.task 'default', ['init', 'html', 'sass', 'img', 'browser-sync'], ->
  gulp.watch ['./src/sass/*.scss', './src/scss/**/*.scss'], ['sass']
  gulp.watch path.srcHTML, ['html']