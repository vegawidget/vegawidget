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

* adds function `vw_rename_data()` to reanme named datasets within a vegaspec (#34)

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
