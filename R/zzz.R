.onLoad <- function(...) {
  vctrs::s3_register("knitr::knit_print", "vegaspec")
}
