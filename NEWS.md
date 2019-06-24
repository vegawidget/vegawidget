# vegawidget 0.2.1

* Upgrade to Vega-Lite 3.3.0, Vega 5.4.0, vega-embed 4.2.0. This is supported by all modern browsers and RStudio IDE 1.2.

## New features

* Update Vega and Vega-Lite libraries to be consistent with Vega-Lite v3.2.1. Add functions to support `addDataListener()` method offered by [vega-view](https://github.com/vega/vega-view#view_addDataListener), use `vw_shiny_demo("data-set-get")` for more information. (#65)

## Improvements and fixes

* Modify `knit_print()` to handle non-HTML formats. Instead of using the [webshot](https://github.com/wch/webshot) package, the `knit_print()` function converts charts to either `png`, `svg` (useful for `github_document`), or `pdf` (useful for `pdf_document`) format. (#44, @AliciaSchep)

* Improve implementation of the `base_url` argument in `vegawidget()`; it works for both local and remote paths. (#63, with @AliciaSchep)

* Update templating functions, splitting to two functions: `use_vegawidget()` and `use_vegawidget_interactive()`, which let you import and re-export basic-rendering and interactive functions, respectively. If your package keeps its version of a spec in its own S3 class, you can call `use_vegawidget()` with that class' name. (#83)

* Move **shiny** from an `Imports` dependency to a `Suggests` dependency. (#82)

* (Of interest to developers) modify the class-naming for Vega-Lite specs, adding a another level of S3 class that describes the type of chart, e.g. unit, layer, facet, etc. (#77)

* Modify contribution guidelines; use `master` as reference branch for all pull-requests.

# vegawidget 0.1.0

* CRAN release

# vegawidget 0.0.7.9000

* changes API and implementation for "image" functions: `vw_to_svg()`, `vw_to_bitmap()`, `vw_write_svg()` , and `vw_write_png()` - these functions require that you have [node](https://nodejs.org/en/) installed on your computer, and the [rsvg](https://CRAN.R-project.org/package=rsvg) package, to use `vw_to_bitmap()` and `vw_write_png()`

# vegawidget 0.0.6.9000

* adds `elementId` argument to `vegawidget()`; had been available as part of `...` passed to `htmlwidgets::createWidget()`

* compiles Shiny demonstration apps in `inst/shiny-demo`, adds function `vw_shiny_demo()`  to access them

* adds Shiny setter-functions: `vw_shiny_set_signal()`, `vw_shiny_set_data()`, `vw_shiny_run()`, getter-functions: `vw_shiny_get_signal()`, `vw_shiny_get_event()`, and handler helper-functions `vw_handler_signal()`, `vw_handler_event()`, `vw_handler_add_effect()`, `vw_handler_compose()`, and `vw_handler_body_compose()`

# vegawidget 0.0.5.9000

* tries a kinder, gentler method for enforcing sizing by implementing a sizing policy rather than overwriting the enclosing element

* deprecates block-functions: `vw_create_block()`, `vw_retrieve_block()`; moved to [vegablock](https://vegawidget.github.io/vegablock)

# vegawidget 0.0.4.9000

* adds learnr tutorial, "Overview"

* adds datasets: `data_seattle_hourly`, `data_seattle_daily`, `data_category` 

* changes default-display for `vw_examine()`

* adds function `vw_rename_data()` to rename named datasets within a vegaspec (#34)

# vegawidget 0.0.4

* updates to Vega-Lite 2.6.0, Vega 4.0.0-rc.3, vega-embed 3.16.0. 

# vegawidget 0.0.3

* adds function `vw_serialize_data()` to help format dates and datetimes in data frames (#33)

* adds function `vega_schema()` to create a string describing a schema-URL (#32)

* adds function `use_vegawidget()` to help other packages use these functions (#21)

* overhauls the API (#15, with @AliciaSchep)

  * changes `write_svg()` -> `vw_write_svg()`
  * changes `write_png()` -> `vw_write_png()`
  * changes `to_vega()` -> `vw_to_vega()`
  * changes `to_svg()` -> `vw_to_svg()`
  * changes `to_png()` -> `vw_to_png()`
  * changes `png_bin()` -> `vw_png_bin()`
  * changes `spec_version()` -> `vw_spec_version()`
  * changes `examine()` -> `vw_examine()`
  * changes `block_retrieve()` -> `vw_retrieve_block()`
  * changes `block_create_gistid()` -> `vw_create_block_gistid()`
  * changes `block_create()` -> `vw_create_block()`
  * changes `block_config()` -> `vw_block_config()`  
  * changes `autosize()` -> `vw_autosize()`
  * changes `as_json()` -> `vw_as_json()`
  * changes `spec_mtcars` -> `spec_mtcars`

# vegawidget 0.0.2

* adds a `NEWS.md` file to track changes to the package
