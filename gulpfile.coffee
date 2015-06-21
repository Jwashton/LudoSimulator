gulp        = require 'gulp'
gutil       = require 'gulp-util'

sass        = require 'gulp-sass'
browserSync = require 'browser-sync'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
jasmine     = require 'gulp-jasmine'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
merge       = require 'merge-stream'

del         = require 'del'

coffee_files = [
  'settings'
  'die'
  'board'
  'player'
  'strategy'
  'view'
  'circle_view'
  'main'
].map (file) ->
  "src/coffee/**/#{file}.coffee"

sources =
  sass:   'src/sass/**/*.scss'
  coffee: coffee_files
  jspec:  'spec/**/*.coffee'

destinations =
  css: 'assets/css'
  js:  'assets/js'

gulp.task 'style', ->
  gulp.src(sources.sass)
  .pipe(sass({outputStyle: 'compressed', errLogToConsole: true}))
  .pipe(gulp.dest(destinations.css))

gulp.task 'lint', ->
  gulp.src(sources.coffee)
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())

gulp.task 'src', ->
  gulp.src(sources.coffee)
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(concat('app.js'))
  .pipe(uglify())
  .pipe(gulp.dest(destinations.js))

gulp.task 'spec', ->
  spec = gulp.src(sources.jspec)
  src  = gulp.src(sources.coffee)
  
  merge(src, spec)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(destinations.js))
    #.pipe(jasmine())

gulp.task 'watch', ->
  gulp.watch sources.sass, ['style']
  gulp.watch sources.coffee, ['lint', 'src']
  gulp.watch sources.jspec, ['spec']

gulp.task 'clean', ->
  del destinations.js
