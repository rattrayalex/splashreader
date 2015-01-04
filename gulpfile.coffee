gulp = require "gulp"

gutil = require("gulp-util")
source = require("vinyl-source-stream")
watchify = require("watchify")
browserify = require("browserify")
coffeeify = require("coffeeify")
minifyify = require("minifyify")
envify = require("envify")
uglifyify = require("uglifyify")
replace = require('gulp-replace')

watch = require("gulp-watch")
less = require("gulp-less")
cssmin = require('gulp-cssmin')
base64 = require('gulp-base64')

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
    .pipe base64
      baseDir: 'css'
      maxImageSize: Infinity
      extensions: ['woff']
      debug: false
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


watchifyFile = (filename, cb) ->
  args = watchify.args
  args.extensions = ['.coffee']
  bundler = watchify(browserify("./coffee/#{filename}.coffee", args), args)
  bundler.transform(coffeeify)
  bundler.transform('brfs')
  bundler.transform('envify')
  if process.env.NODE_ENV is "production"
    bundler.transform({global: true}, 'uglifyify')
  # to tell React we're in prod... wasn't working, I gave up
  # bundler.transform envify
  #   _: 'purge'
  #   NODE_ENV: 'production'
  #   # NODE_ENV: 'development'
  bundler.ignore('iconv')

  rebundle = ->
    gutil.log gutil.colors.green 'rebundling...'
    bundler.bundle()
      .on "error", gutil.log.bind(gutil, "Browserify Error")
      # I'm not really sure what this line is all about?
      .pipe source("#{filename}.js")
      .pipe gulp.dest("js")
      .pipe livereload()

    if cb
      cb()

    gutil.log gutil.colors.green 'rebundled.'

  bundler.on "update", rebundle
  rebundle()


gulp.task "watchify", ->
  # watchifyFile 'static', ->
  #   reactHtml = require('./coffee/static')
  #   gulp.src "index.html"
  #     .pipe replace /\<body\>[\s\S]*\<\/body\>/, "<body>#{ reactHtml() }</body>"
  #     .pipe gulp.dest("index2.html")
  watchifyFile 'app'
  watchifyFile 'chrome'
  watchifyFile 'chromeBrowserAction'


gulp.task "default", ["watchify", "serve", "less", "watch"]

# for conserving battery (apparently gulp uses helza battery)
gulp.task "lite", ["serve"], ->
  watchifyFile 'app'
