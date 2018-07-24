# these are the internal functions used to support vegaspec operations

.as_vegaspec <- function(x, ...) {
  UseMethod(".as_vegaspec")
}

.as_vegaspec.default <- function(x, ...) {
  stop("as_vegaspec(): no method for class ", class(x), call. = FALSE)
}

.as_vegaspec.list <- function(x, ...) {

  # determine if this is a vega or vegalite spec
  library <- .schema_type(x[["$schema"]])$library

  class_library <- paste0("vegaspec_", library)

  class_new <- unique(c(class_library, "vegaspec", class(x)))

  spec <- structure(x, class = class_new)

  spec
}

.as_list <- function(x, ...) {
  UseMethod(".as_list")
}

.as_list.default <- function(x, ...) {
  stop(".as_list(): no method for class ", class(x), call. = FALSE)
}

.as_list.vegaspec <- function(x, ...) {
  # revert to list
  unclass(x)
}

.as_list.json <- function(x, ...) {
  # convert from JSON to list
  x <- jsonlite::fromJSON(x, simplifyVector = FALSE, simplifyDataFrame = FALSE)

  x
}


.as_json <- function(x, pretty, ...) {
  UseMethod(".as_json")
}

.as_json.default <- function(x, pretty, ...) {
  stop(".as_json(): no method for class ", class(x), call. = FALSE)
}

.as_json.list <- function(x, pretty = TRUE, ...) {
  # convert from list to JSON
  jsonlite::toJSON(x, auto_unbox = TRUE, pretty = pretty)
}

.as_json.character <- function(x, pretty = TRUE, ...) {

  # validate that this is JSON
  success <- jsonlite::validate(x)
  assertthat::assert_that(
    success,
    msg = attr(success, "err")
  )

  # add json class to character
  class(x) <- unique(c("json", class(x)))

  x
}





