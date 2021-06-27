async function vwFetch(url, options) {
  const result = console.r.call('vegawidget::vw_fetch', url);

  return(result);
}

async function vwLoad(filename) {
  const result = await console.r.call('vegawidget::vw_load', filename);

  return(result);
}
