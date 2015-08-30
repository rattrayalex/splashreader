var autoprefixer = require('autoprefixer-core');
var csswring = require('csswring');


module.exports = {
  context: __dirname + "/src",
  entry: "./index.js",

  output: {
    filename: "app.js",
    path: __dirname + "/dist",
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loaders: ["babel-loader"],
      },
      { // ref: https://github.com/postcss/postcss-loader
        test:   /\.css$/,
        loader: "style-loader!css-loader!postcss-loader",
      },
      {
        test: /\.(png|jpg)$/,
        loader: 'url-loader',
        // loader: 'url-loader?limit=8192',
      },
    ],
  },

  postcss: function () {
    return [autoprefixer, csswring]
  },

}