gulp = require "gulp"

gutil = require("gulp-util")
source = require("vinyl-source-stream")
watchify = require("watchify")
browserify = require("browserify")
coffeeify = require("coffeeify")
minifyify = require("minifyify")

watch = require("gulp-watch")
less = require("gulp-less")
cssmin = require('gulp-cssmin')

ecstatic = require "ecstatic"
http = require "http"
livereload = require "gulp-livereload"


gulp.task "serve", ->
  http.createServer(
    ecstatic
      root: __dirname
  ).listen(8080)


# currently unused; run if you ever update bootstrap!
gulp.task "fonts", ->
  gulp.src "node_modules/bootstrap/fonts/*"
    .pipe gulp.dest("fonts")


gulp.task "less", ->
  gulp.src "style.less"
    .pipe less()
    .pipe cssmin()
    .pipe gulp.dest('css')
    .pipe livereload()


gulp.task "html", ->
  gulp.src "index.html"
    .pipe livereload()


gulp.task "watch", ->
  gulp.watch "style.less", ["less"]
  gulp.watch "index.html", ["html"]


gulp.task "sourcemap", ['serve'], ->
  args =
    extensions: ['.coffee']
    debug: true

  bundler = browserify("./coffee/app.coffee", args)
  bundler.transform(coffeeify)
  bundler.plugin minifyify,
    map: '/js/bundle.map.json'
    output: 'js/bundle.map.json'

  bundler.bundle()
    .on "error", gutil.log.bind(gutil, "Browserify Error")
    # I'm not really sure what this line is all about?
    .pipe source("app.js")
    .pipe gulp.dest("js")


gulp.task "watchify", ->
  args = watchify.args
  args.extensions = ['.coffee']
  bundler = watchify(browserify("./coffee/app.coffee", args), args)
  bundler.transform(coffeeify)
  bundler.ignore('iconv')

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

gulp.task "default", ["watchify", "serve", "less", "watch"]
