gulp = require 'gulp'
fs = require 'fs'
concat = require 'gulp-concat'
minifycss = require 'gulp-minify-css'
autoprefixer = require 'gulp-autoprefixer'
notify = require 'gulp-notify'
rename = require 'gulp-rename'
sass = require 'gulp-sass'
uglify = require 'gulp-uglify'
browserSync = require 'browser-sync'

path =
  sass: './src/sass/**/*.scss'
  css:  './www/css'
  srcImg: './src/img/*'
  img:  './www/img'
  srcJs:  './src/js/**/*.js'
  js:  './www/js'
  srcHtml: './src/*.html'
  www: './www'

gulp.task 'clean', ->
  fs.rmdirSync(path.js)
  fs.rmdirSync(path.css)
  fs.rmdirSync(path.www)

gulp.task 'init', ->
  fs.mkdir path.www, '0777' if not fs.existsSync(path.www)
  fs.mkdir path.css, '0777' if not fs.existsSync(path.css)
  fs.mkdir path.js, '0777' if not fs.existsSync(path.js)
  fs.mkdir path.img, '0777' if not fs.existsSync(path.img)

gulp.task 'html', ->
  gulp.src(path.srcHtml)
  .pipe gulp.dest(path.www)

gulp.task 'img', ->
  gulp.src(path.srcImg)
  .pipe gulp.dest(path.img)

gulp.task 'sass', ->
  gulp.src(path.sass)
  .pipe sass(includePaths: ['scss'])
  .pipe autoprefixer("last 2 version", "> 1%", "ie 8", "ie 9", "ios 6", "android 4")
  .pipe minifycss()
  .pipe gulp.dest(path.css)
  .pipe browserSync.reload(stream: true)

gulp.task 'browser-sync', ->
  browserSync.init null,
    server:
      baseDir: path.www

gulp.task 'bs-reload', ->
  browserSync.reload()

gulp.task 'watch', ->
  gulp.watch path.sass, ['sass', 'bs-reload']
  gulp.watch path.srcHtml, ['html', 'bs-reload']

gulp.task 'default', ['init', 'html', 'img', 'sass', 'browser-sync', 'watch']