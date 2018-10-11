Package infrastrucure
================

This purpose of this document is to build the package infrastucture.

To upgrade the version of **Vega-Lite** that we support:

1.  Modify the parameter `vega_lite_version` in the yaml-header to this
    file.
2.  Render (knit) this document.
3.  Build-and-install this package on your local computer.
4.  Run the tests (`testthat::test()`).
5.  Rebuild the pkgdown website (`pkgdown::build_site()`), verify the
    visual-regression article (still to be built).
6.  Commit, push, and make PR.

<!-- end list -->

``` r
library("fs")
library("glue")
library("httr")
library("here")
```

    ## here() starts at /Users/lees159/vegawidget

``` r
library("purrr")
library("readr")
library("dplyr")
```

    ## Warning: package 'dplyr' was built under R version 3.5.1

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:glue':
    ## 
    ##     collapse

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library("tibble")
library("stringr")
library("usethis")
library("conflicted")
library("vegawidget")
```

## Infrastructure

Package infrastucture incudes:

  - an htmlwidget named “vegawidget”
  - internal package data:
      - list of version numbers: `.vega_version`
      - strings of minified javascript libraries: `.vega_js`,
        `.vega_polyfill_symbol_js`, `.vega_polyfill_promise_js`,
        `.vega_lite_js` (perhaps the js libraries could use the
        htmldependency and memoise)
  - public package data:
      - `spec_mtcars` vegaspec for an mtcars scatterplot
  - files to create a [block](https://bl.ocks.org)
  - files to validate the schema

Perhaps this could be a series of documents - it remains as an exercise
to see what can be cleaved away.

There are two source of “truth” for this process: this document, and the
contents of the directory `data-raw/templates`. (It may be useful to
note this in a “contributing” document for this package.) Each of the
infrastructure elements is created anew when this document is run; so,
between this document and `data-raw/templates`, we need to be able to
construct completely each element infrastructure.

Thus, we define this template directory and a function to delete and
create

``` r
dir_templates <- here("data-raw", "templates")

# create a create a clean directory, with a safety
create_clean <- function(path, path_safe = here::here()) {
  
  # tests that path is within path_safe
  is_path_safe <- function(path, path_safe) {
    identical(
      unclass(path_safe), 
      unclass(fs::path_common(c(path, path_safe)))
    )
  }
  
  if (!is_path_safe(path, path_safe)) {
    stop(
      "Nothing done because ",
      " path: ", shQuote(path), 
      " is not within path_safe: ", shQuote(path_safe)
    )
  }
  
  if (fs::dir_exists(path)) {
    fs::dir_delete(path)
  }
  
  fs::dir_create(path)
  
}
```

## Configure

These packages are not listed in the `Suggests` section of the
`DESCRIPTION` file. It’s on you to make sure they are all up-to-date.

We need to know which versions of the libraries (vega, vega-lite, and
vega-embed) to download. We do this by inspecting the manifest of a
specific version of the vega-lite library. This package has an internal
function, `vega_version()` to help us do this:

``` r
vega_version_long <- get_vega_version(params$vega_lite_version)

vega_version_long
```

    ## $vega_lite
    ## [1] "2.6.0"
    ## 
    ## $vega
    ## [1] "4.0.0-rc.3"
    ## 
    ## $vega_embed
    ## [1] "3.16.0"

``` r
# we want to remove the "-rc.2" from the end of "4.0.0-rc.2"
# "-\\w.*$"   hyphen, followed by a letter, followed by anything, then end 
vega_version_short <- map(vega_version_long, ~sub("-\\w.*$", "", .x))
```

## htmlwidgets

First, let’s create a clean directory for the htmlwidget

``` r
dir_htmlwidgets <- here("inst", "htmlwidgets")
dir_lib <- path(dir_htmlwidgets, "lib")
dir_vegaembed <- path(dir_lib, "vega-embed")

create_clean(dir_htmlwidgets)
dir_create(dir_lib)
dir_create(dir_vegaembed)
```

### vegawidget

First, copy some files from our templates directory.

``` r
file_copy(
  path(dir_templates, "vegawidget.js"), 
  path(dir_htmlwidgets, "vegawidget.js"),
  overwrite = TRUE # take this out when done
)
```

The file `vegawidget.yaml` requires the versions the JavaScript
libraries; we interpolate these from `vega_version_short`.

``` r
path(dir_templates, "vegawidget.yaml") %>%
  read_lines() %>%
  map_chr(~glue_data(vega_version_short, .x)) %>%
  write_lines(path(dir_htmlwidgets, "vegawidget.yaml"))
```

The file `vega-embed.css` adds some css for the (old-style) links that
appeared below a rendered spec:

``` r
fs::file_copy(
  fs::path(dir_templates, "vega-embed.css"), 
  fs::path(dir_vegaembed, "vega-embed.css")
)
```

Here’s where we download the libraries themselves, along with the
licences; the versions are interpolated from `vega_version_long`.

``` r
htmlwidgets_downloads <-
  tribble(
    ~path_local,                         ~path_remote,
    "vega-lite/vega-lite.min.js",        "https://cdn.jsdelivr.net/npm/vega-lite@{vega_lite}",
    "vega-lite/LICENSE",                 "https://raw.githubusercontent.com/vega/vega-lite/master/LICENSE",
    "vega/promise.min.js",               "https://vega.github.io/vega/assets/promise.min.js",
    "vega/symbol.min.js",                "https://vega.github.io/vega/assets/symbol.min.js",
    "vega/vega.min.js",                  "https://cdn.jsdelivr.net/npm/vega@{vega}",
    "vega/vega.js",                      "https://cdn.jsdelivr.net/npm/vega@{vega}/build/vega.js",
    "vega/LICENSE",                      "https://raw.githubusercontent.com/vega/vega/master/LICENSE",
    "vega-embed/vega-embed.js",          "https://cdn.jsdelivr.net/npm/vega-embed@{vega_embed}",
    "vega-embed/LICENSE",                "https://raw.githubusercontent.com/vega/vega-embed/master/LICENSE"
  ) %>%
  mutate(
    path_remote = map_chr(path_remote, ~glue_data(vega_version_long, .x))
  )

htmlwidgets_downloads
```

    ## # A tibble: 9 x 2
    ##   path_local             path_remote                                      
    ##   <chr>                  <chr>                                            
    ## 1 vega-lite/vega-lite.m… https://cdn.jsdelivr.net/npm/vega-lite@2.6.0     
    ## 2 vega-lite/LICENSE      https://raw.githubusercontent.com/vega/vega-lite…
    ## 3 vega/promise.min.js    https://vega.github.io/vega/assets/promise.min.js
    ## 4 vega/symbol.min.js     https://vega.github.io/vega/assets/symbol.min.js 
    ## 5 vega/vega.min.js       https://cdn.jsdelivr.net/npm/vega@4.0.0-rc.3     
    ## 6 vega/vega.js           https://cdn.jsdelivr.net/npm/vega@4.0.0-rc.3/bui…
    ## 7 vega/LICENSE           https://raw.githubusercontent.com/vega/vega/mast…
    ## 8 vega-embed/vega-embed… https://cdn.jsdelivr.net/npm/vega-embed@3.16.0   
    ## 9 vega-embed/LICENSE     https://raw.githubusercontent.com/vega/vega-embe…

``` r
get_file <- function(path_local, path_remote, path_local_root) {
  
  path_local <- fs::path(path_local_root, path_local)
  
  # if directory does not yet exist, create it
  # TODO: swap out with create_clean()
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

Here, we create the `lib` directory, then “walk” through each row of the
`downloads` data frame to get each of the files and put it into place.

``` r
pwalk(htmlwidgets_downloads, get_file, path_local_root = dir_lib)
```

### Patch

Here, Alicia Schep noticed that there was a problem to render vega
charts within the RStudio IDE, and she figured out a workaround (as well
as a PR for the RStudio IDE to fix the problem). Here’s her patch for
older versions of the IDE:

``` r
vega_embed_path <- path(dir_lib, "vega-embed/vega-embed.js")
vega_embed <- readr::read_file(vega_embed_path)

vega_mod <- stringr::str_replace_all(vega_embed, 'head>"','he"+"ad>"') 
vega_mod <- stringr::str_replace_all(vega_mod, '"<\\/head>','"</he"+"ad>') 

readr::write_file(vega_mod, path(dir_lib, "vega-embed/vega-embed-modified.js"))
fs::file_delete(vega_embed_path)
```

## Block

These are the files used with `create_block()`

``` r
dir_block <- here("inst", "block")
create_clean(dir_block)
```

``` r
fs::file_copy(
  fs::path(dir_templates, "index.html"), 
  fs::path(dir_block, "index.html")
)
```

## Schema

One of the purposes of this package is to provide a means to validate a
spec.

``` r
dir_schema <- here("inst", "schema")
create_clean(dir_schema)
```

Having thought about this (perhaps too much), the only reasonable way to
go for a given release to support only a single version of the
javascript libraries and the schema.

``` r
schema <- 
  tribble(
    ~path_local,                   ~path_remote,
    "vega/v{vega}.json",           "https://vega.github.io/schema/vega/v{vega}.json",
    "vega-lite/v{vega_lite}.json", "https://vega.github.io/schema/vega-lite/v{vega_lite}.json"
  ) %>%
  mutate(
    path_local = map_chr(path_local, ~glue_data(vega_version_long, .x)),
    path_remote = map_chr(path_remote, ~glue_data(vega_version_long, .x))
  )

schema
```

    ## # A tibble: 2 x 2
    ##   path_local            path_remote                                        
    ##   <chr>                 <chr>                                              
    ## 1 vega/v4.0.0-rc.3.json https://vega.github.io/schema/vega/v4.0.0-rc.3.json
    ## 2 vega-lite/v2.6.0.json https://vega.github.io/schema/vega-lite/v2.6.0.json

``` r
pwalk(schema, get_file, path_local_root = dir_schema)
```

## Public data

The data are documented in `R/data.R`.

``` r
spec_mtcars <-
  as_vegaspec(
    list(
      `$schema` = "https://vega.github.io/schema/vega-lite/v2.json",
      width = 300L,
      height = 300L,
      description = "An mtcars example.",
      data = list(values = mtcars),
      mark = "point",
      encoding = list(
        x = list(field = "wt", type = "quantitative"),
        y = list(field = "mpg", type = "quantitative"),
        color = list(field = "cyl", type = "nominal")
      )
    )     
  )
```

``` r
usethis::use_data(spec_mtcars, overwrite = TRUE)
```

    ## ✔ Setting active project to '/Users/lees159/vegawidget'
    ## ✔ Saving 'spec_mtcars' to 'data/spec_mtcars.rda'

## Internal data

### Versions

We use this to support the `vega_version()` function.

``` r
.vega_version <- vega_version_long
```

### JavaScript Libraries

We want to keep copies of the Vega and Vega-Lite specs so that we can
use them with V8.

Another way to do this may be to keep memoised functions that read the
files kept in the htmlwidgets directory. This seems potentially cleaner
to execute, but more-complicated to implement.

Let look at `htmlwidgets_downloads`

``` r
regex <- "vega(-lite)?/(.*)\\.min.js$"

htmlwidgets_vegajs <-
  htmlwidgets_downloads %>%
  dplyr::filter(str_detect(path_local, regex)) %>%
  dplyr::mutate(
    name = str_replace(path_local, regex, ".\\2_js") %>% str_replace("-", "_")
  ) %>%
  dplyr::select(name, path_local)

htmlwidgets_vegajs  
```

    ## # A tibble: 4 x 2
    ##   name          path_local                
    ##   <chr>         <chr>                     
    ## 1 .vega_lite_js vega-lite/vega-lite.min.js
    ## 2 .promise_js   vega/promise.min.js       
    ## 3 .symbol_js    vega/symbol.min.js        
    ## 4 .vega_js      vega/vega.min.js

We need to put these into the local environment. This smells like a
side-effect.

``` r
assign_js <- function(name, path_local, path_root) {
  
  js <- readr::read_file(fs::path(path_root, path_local))
  
  assign(name, js, envir = globalenv())
  NULL 
}

pwalk(htmlwidgets_vegajs, assign_js, path_root = dir_lib)
```

``` r
devtools::use_data(
  .vega_version, 
  .vega_js,
  .vega_lite_js,
  .promise_js,
  .symbol_js,
  internal = TRUE, 
  overwrite = TRUE
)
```

    ## Saving .vega_version, .vega_js, .vega_lite_js, .promise_js, .symbol_js as sysdata.rda to /Users/lees159/vegawidget/R
