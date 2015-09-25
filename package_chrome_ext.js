/*eslint-env node */
'use strict'
let archiver = require('archiver')
let fs = require('fs')

let archive = archiver.create('zip', {})

archive.pipe(fs.createWriteStream(__dirname + '/splashreader_chrome_ext.zip'))
archive.bulk([
  { src: ['dist/**'] },
  { src: ['images/icon*.png'] },
  { src: ['manifest.json'] },
])
archive.finalize()

