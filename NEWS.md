# vegawidget 0.0.3

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
  * changes `block_build_directory()` -> `vw_block_build_directory()`
  * changes `block_index()` -> `vw_block_index()`
  * changes `block_create_gistid()` -> `vw_create_block_gistid()`
  * changes `block_create()` -> `vw_create_block()`
  * changes `block_config()` -> `vw_block_config()`  
  * changes `autosize()` -> `vw_autosize()`
  * changes `as_json()` -> `vw_as_json()`
  * changes `spec_mtcars` -> `vw_ex_mtcars`

# vegawidget 0.0.2

* Added a `NEWS.md` file to track changes to the package.