// postcss.config.js
const postcssImport = require('postcss-import');
const tailwindcss = require('tailwindcss');
const autoprefixer = require('autoprefixer');

module.exports = {
  plugins: [postcssImport, tailwindcss, autoprefixer],
};
