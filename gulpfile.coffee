gulp = require "gulp"

gutil = require("gulp-util")
source = require("vinyl-source-stream")
watchify = require("watchify")
browserify = require("browserify")
coffeeify = require("coffeeify")

ecstatic = require "ecstatic"
http = require "http"
livereload = require "gulp-livereload"


gulp.task "serve", ->
  http.createServer(
    ecstatic
      root: __dirname
  ).listen(8080)

gulp.task "watchify", ->
  args = watchify.args
  args.extensions = ['.coffee']
  bundler = watchify(browserify("./coffee/app.coffee", args), args)
  bundler.transform(coffeeify)

  rebundle = ->
    gutil.log gutil.colors.green 'rebundling...'
    bundler.bundle()
      # log errors if they happen
      .on "error", gutil.log.bind(gutil, "Browserify Error")
      # I'm not really sure what this line is all about?
      .pipe source("app.js")
      .pipe gulp.dest("js")
      .pipe livereload()
    gutil.log gutil.colors.green 'rebundled.'

  bundler.on "update", rebundle
  rebundle()

gulp.task "default", ["watchify", "serve"]
