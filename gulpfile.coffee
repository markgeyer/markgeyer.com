gulp = require 'gulp'
fs = require 'fs'
minifycss = require 'gulp-minify-css'
autoprefixer = require 'gulp-autoprefixer'
sass = require 'gulp-sass'
browserSync = require 'browser-sync'

path =
  sass: './src/sass/**/*.scss'
  css:  './www/css'
  srcIMG: './src/img/*'
  img:  './www/img'
  srcJS:  './src/js/**/*.js'
  js:  './www/js'
  srcHTML: './src/*.html'
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
  gulp.src(path.srcHTML)
  .pipe gulp.dest(path.www)

gulp.task 'img', ->
  gulp.src(path.srcIMG)
  .pipe gulp.dest(path.img)

gulp.task 'sass', ->
  gulp.src(path.sass)
  .pipe sass(includePaths: ['scss'])
  .pipe(autoprefixer("last 1 version", "> 1%", "ie 10", "iOS 7", "Android 4", cascade: true))
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
  gulp.watch path.srcHTML, ['html', 'bs-reload']

gulp.task 'default', ['init', 'html', 'img', 'sass', 'browser-sync', 'watch']