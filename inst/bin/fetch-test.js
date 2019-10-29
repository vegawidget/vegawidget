// Reimagining a new script to create svg


// Read in arguments
// First argument is the directory of the R package -- where to find JS
const url = process.argv[2];

fetch = require('node-fetch');

const response = fetch(url).then(function(value) {
  return value.text();
}).then(console.log);


