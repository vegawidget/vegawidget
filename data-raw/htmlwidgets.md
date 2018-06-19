htmlwidgets lib files
================

The purpose of this document is to assemble the files for the
`inst/htmlwidgets` directory.

To construct the `inst/htmlwidgets` directory, we have two “sources of
truth”: this file and the contents of the directory
`data-raw/templates/vegawidget`.

The **only** way to put anything in the `inst/htmlwidgets` directory is
to run this file.

## Configure

``` r
library("conflicted")
library("fs")
library("glue")
library("httr")
library("here")
```

    ## here() starts at /Users/ijlyttle/Documents/git/github/vegawidget/vegawidget

``` r
library("tibble")
library("purrr")
library("readr")
library("dplyr")
library("vegawidget")
```

``` r
dir_htmlwidgets <- here("inst", "htmlwidgets")
dir_templates <- here("data-raw", "templates")

vega_versions_long <- vega_versions(params$vega_lite_version)

# we want to remove the "-rc.2" from the end of "4.0.0-rc.2"
# "-\\w.*$"   hyphen, followed by a letter, followed by anything, then end 
vega_versions_short <- map(vega_versions_long, ~sub("-\\w.*$", "", .x))
```

## Clean and create

Our first task is to create a clean directory `inst/htmlwidgets`.

``` r
params$dir_htmlwidgets
```

    ## NULL

``` r
if (dir_exists(dir_htmlwidgets)) {
  dir_delete(dir_htmlwidgets)
}

dir_create(dir_htmlwidgets)
```

## Vegawidget files

We have a couple of files to copy from our templates directory.

``` r
file_copy(
  path(dir_templates, "vegawidget.js"), 
  path(dir_htmlwidgets, "vegawidget.js")
)
```

``` r
path(dir_templates, "vegawidget.yaml") %>%
  read_lines() %>%
  map_chr(~glue_data(vega_versions_short, .x)) %>%
  write_lines(path(dir_htmlwidgets, "vegawidget.yaml"))
```

## Lib directory

``` r
downloads <-
  tribble(
    ~path_local,                         ~path_remote,
    "vega-lite/vega-lite-min.js",        "https://cdn.jsdelivr.net/npm/vega-lite@{vega_lite}",
    "vega-lite/LICENSE",                 "https://raw.githubusercontent.com/vega/vega-lite/master/LICENSE",
    "vega/promise.min.js",               "https://vega.github.io/vega/assets/promise.min.js",
    "vega/symbol.min.js",                "https://vega.github.io/vega/assets/symbol.min.js",
    "vega/vega.js",                      "https://cdn.jsdelivr.net/npm/vega@{vega}/build/vega.js",
    "vega/LICENSE",                      "https://raw.githubusercontent.com/vega/vega/master/LICENSE",
    "vega-embed/vega-embed.js",          "https://cdn.jsdelivr.net/npm/vega-embed@{vega_embed}",
    "vega-embed/LICENSE",                "https://raw.githubusercontent.com/vega/vega-embed/master/LICENSE"
  ) %>%
  mutate(
    path_remote = map_chr(path_remote, ~glue_data(vega_versions_long, .x))
  ) %>%
  identity()
```

``` r
get_file <- function(path_local, path_remote, lib_dir) {
  
  path_local <- fs::path(lib_dir, path_local)
  
  # if directory does not yet exist, create it
  dir_local <- fs::path_dir(path_local)
  
  if (!fs::dir_exists(dir_local)) {
    dir_create(dir_local)
  }
  
  resp <- httr::GET(path_remote)
  
  text <- httr::content(resp, type = "text", encoding = "UTF-8")
  
  readr::write_file(text, path_local)
  
  invisible(NULL)
}
```

``` r
dir_lib <- path(dir_htmlwidgets, "lib")
dir_create(dir_lib)

pwalk(downloads, get_file, lib_dir = dir_lib)
```

## Patch

``` r
vega_embed_path <- path(dir_lib, "vega-embed/vega-embed.js")
vega_embed <- readr::read_file(vega_embed_path)

vega_mod <- stringr::str_replace_all(vega_embed, 'head>"','he"+"ad>"') 
vega_mod <- stringr::str_replace_all(vega_mod, '"<\\/head>','"</he"+"ad>') 

readr::write_file(vega_mod, path(dir_lib, "vega-embed/vega-embed-modified.js"))
fs::file_delete(vega_embed_path)
```
