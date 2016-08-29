/* eslint-env node */
/* eslint-disable import/no-extraneous-dependencies */
const path = require('path')
const webpack = require('webpack')

const PROD = (process.env.NODE_ENV || '').toLowerCase() === 'production'

const filename = PROD ? 'app.min.js' : 'app.js'
const devtool = PROD ? null : 'source-map-eval'
const plugins = PROD
  ? [new webpack.optimize.UglifyJsPlugin({ compress: { warnings: false } })]
  : []

module.exports = {
  context: path.join(__dirname, '/src'),
  entry: './index.js',

  output: {
    filename,
    path: path.join(__dirname, '/dist'),
  },

  devtool,
  plugins,

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loaders: ['babel-loader'],
      },
      { // ref: https://github.com/postcss/postcss-loader
        test: /\.css$/,
        loader: 'style!css?module!postcss-loader',
      },
      {
        test: /\.(png|jpg)$/,
        loader: 'url-loader',
        // loader: 'url-loader?limit=8192',
      },
    ],
  },

}
