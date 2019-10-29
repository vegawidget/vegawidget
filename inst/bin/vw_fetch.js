// one day, hopes to be a function that could stand in for fetch()
// - would call back to httr

async function vwFetch(url, opts) {

  try {
    let found = await console.r.call("paste0", [url, " bar"]);
    return found;
  } catch (_) {}

  throw new Error("Not found");
}


