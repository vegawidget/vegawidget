#!/usr/bin/env node
// Render a Vega specification to SVG
// Adapted from vega-cli

const svgHeader =
  '<?xml version="1.0" encoding="utf-8"?>\n' +
  '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" ' +
  '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n';

// import required libraries
const path = require('path'),
fs = require('fs');

// Read in arguments
// First argument is the directory of the R package -- where to find JS
const pkgDir = process.argv[2];
// Second argument is the location of spec file.
const specFile = process.argv[3];
// Third argument is random seed
const seed = process.argv[4];
// Fourth argument is base URL
const base = process.argv[5];

// Load fetch so that it can be used by vega for remote data
fetch = require('node-fetch');

// Get paths to the JS files
const vega_path = path.join(pkgDir, 'htmlwidgets','lib','vega','vega.min.js');

// Load the JS
var vega = require(vega_path);

function lcg(seed) {
  // Random numbers using a Linear Congruential Generator with seed value
  // Uses glibc values from https://en.wikipedia.org/wiki/Linear_congruential_generator
  return function() {
    seed = (1103515245 * seed + 12345) % 2147483647;
    return seed / 2147483647;
  };
}

// Plug-in a deterministic random number generator for testing.
vega.setRandom(lcg(seed));

fs.readFile(specFile, 'utf8', function(err, text) {
  if (err) throw err;
  var spec = JSON.parse(text);
  render(spec);
});


function render(spec) {
  new vega.View(vega.parse(spec), {
    loader: vega.loader({baseURL: base}),
    logLevel: vega.Warn,
    renderer: 'none'
  })
  .initialize()
  .finalize()
  .toSVG()
  .then(svg => { writeSVG(svg); })
  .catch(err => { console.error(err); });
}

function writeSVG(svg) {
  svg = svgHeader + svg;
  process.stdout.write(svg);
}
