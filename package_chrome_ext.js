/* eslint-env node */
'use strict'

const archiver = require('archiver')
const fs = require('fs')
const path = require('path')

const archive = archiver.create('zip', {})
const targetPath = path.join(__dirname, '/splashreader_chrome_ext.zip')

archive.pipe(fs.createWriteStream(targetPath))
archive.bulk([
  { src: ['dist/app.js'] },
  { src: ['images/icon*.png'] },
  { src: ['manifest.json'] },
  { src: ['background.js'] },
])
archive.finalize()

