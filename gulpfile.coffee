gulp = require "gulp"

coffeeify = require "gulp-coffeeify"
coffeelint = require "gulp-coffeelint"

ecstatic = require "ecstatic"
http = require "http"
livereload = require "gulp-livereload"


gulp.task "serve", ->
  http.createServer(
    ecstatic
      root: __dirname
  ).listen(8080)

gulp.task "coffee", ->
  gulp.src "coffee/app.coffee"
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    .pipe coffeeify()
    .pipe gulp.dest('js')
    .pipe livereload()

gulp.task "watch", ->
  gulp.watch "coffee/**/*.coffee", ["coffee"]

gulp.task "default", ["coffee", "serve", "watch"]