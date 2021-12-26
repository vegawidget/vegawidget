// Render a Vega specification to SVG

// functions to call back to R for fetching a remote URL, or loading a local file
async function vwFetch(url, options) {

  const response = await console.r.call('vegawidget::vw_fetch', url);

  if (options.response === 'json') {
    return JSON.parse(response);
  }

  return response;
}

async function vwLoad(fileName) {

  const result = await console.r.call('vegawidget::vw_load', fileName);

  return result;
}

// Adapted from vega-cli: https://github.com/vega/vega/blob/master/packages/vega-cli/bin/vg2svg
async function vwRender(spec, seed, baseURL) {

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

  var vwLoader = vega.loader({baseURL: baseURL});
  vwLoader.http = vwFetch;
  vwLoader.file = vwLoad;

  const result = new vega.View(vega.parse(spec), {
    loader: vwLoader,
    logLevel: vega.Warn,
    renderer: 'none'
  })
    .initialize()
    .finalize()
    .toSVG()
    .then(svg => {

      const svgHeader =
        '<?xml version="1.0" encoding="utf-8"?>\n' +
        '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" ' +
        '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n';

      return svgHeader + svg;;
    })
    .catch(err => { console.log(err); });

  return result;
}


