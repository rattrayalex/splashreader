#!/usr/bin/env coffee
sh = require 'shelljs'

if not sh.which 'git'
  sh.echo 'Sorry, this script requires git'
  sh.exit 1

cmd = (cmd, opts={}) ->
  console.log ''
  console.log "-> #{cmd}"
  sh.exec cmd, opts

getCurrentBranch = ->
  cmd 'git branch', silent: true
    .output
    .match /\* (.+)/
    .slice(1, 2)
    .pop()

checkClean = ->
  out = cmd 'git status'
    .output
  if not out.match "nothing to commit, working directory clean"
    console.log out
    throw new Error "You are dirty!"

runGulpOnce = (next) ->
  lines = []
  proc = sh.exec 'gulp', (code, out) ->
    console.log 'process has exited'
    next()

  proc.stdout.on 'data', (data) ->
    if data.match 'app.js was reloaded.'
      console.log 'exiting process...'
      proc.kill()


main = ->
  checkClean()
  if getCurrentBranch() isnt 'master'
    console.warn 'must be on master'
    return

  cmd 'git checkout gh-pages'
  cmd 'git merge master'

  runGulpOnce ->

    cmd 'git add .'
    cmd "git commit -m 'build/deploy on #{ new Date() }'"
    checkClean()
    cmd "git push"
    cmd "git checkout master"

    console.log "all done!"

main()

