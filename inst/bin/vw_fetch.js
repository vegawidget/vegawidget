// one day, hopes to be a function that could stand in for fetch()
// - would call back to httr

async function vwFetch(url, opts) {

  function cat(x) {
    return x + " bar";
  }

  try {
    let found = await cat(url);
    return found;
  } catch (_) {}

  throw new Error("Not found");
}


