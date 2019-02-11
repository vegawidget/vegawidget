#!/usr/bin/env node
// Compile a Vega-Lite spec to Vega
// Adapted from vg2vl in vega-lite package

'use strict';

// Read in arguments
// First argument is the directory of the R package -- where to find JS
var pkgDir = process.argv[2];
// Second argument is the location of spec file.
var specFile = process.argv[3];

// Load modules (should be included with node)
var fs = require('fs');
var path = require('path');

// Get paths to the JS files
var vega_path = path.join(pkgDir, 'htmlwidgets','lib','vega','vega.min.js');
var vl_path = path.join(pkgDir, 'htmlwidgets','lib','vega-lite','vega-lite.min.js');

// Load the JS and run
var vega = require(vega_path);
var vl = require(vl_path);

// Now read in the spec and compile
fs.readFile(specFile, 'utf8', function(err, text) {
  if (err) throw err;
  var spec = JSON.parse(text);
  var result = vl.compile(spec);
  var vgSpec = result.spec;
  process.stdout.write(JSON.stringify(vgSpec) + '\n');
});


