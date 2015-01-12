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


runGulpOnceThen = (next) ->
  lines = []
  proc = sh.exec 'NODE_ENV=production gulp', (code, out) ->
    console.log 'process has exited'
    next()

  proc.stdout.on 'data', (data) ->
    lines.push(data)
    if gulpIsDone(lines)
      console.log 'exiting process...'
      proc.kill()


gulpIsDone = (lines) ->
  reqs = [
    'chrome.js was reloaded.'
    'app.js was reloaded.'
    # yes, it should happen twice (not sure why...)
    'chrome.js was reloaded.'
  ]
  num_reqs = 0
  for line in lines
    for req in reqs
      if line.match req
        num_reqs += 1
        reqs.shift()
        break

  if num_reqs > 2
    true
  else
    false


main = ->
  checkClean()
  if getCurrentBranch() isnt 'master'
    console.warn 'must be on master'
    return

  cmd 'git checkout gh-pages'
  cmd 'git merge master'

  runGulpOnceThen ->

    cmd 'git add .'
    cmd "git commit -m 'build/deploy on #{ new Date() }'"
    checkClean()
    cmd "git push"
    cmd "git checkout master"

    # gulp freaks out when this disappears, which happens during checkout
    cmd "touch js/app.js"

    console.log "all done!"

main()

