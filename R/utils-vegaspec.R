# these are the internal functions used to support vegaspec operations

.as_vegaspec <- function(x, ...) {
  UseMethod(".as_vegaspec")
}

.as_vegaspec.default <- function(x, ...) {
  stop("as_vegaspec(): no method for class ", class(x), call. = FALSE)
}

.as_vegaspec.list <- function(x, ...) {

  # if no `$schema` element, add one
  if (!("$schema" %in% names(x))) {
    warning(
      "Spec has no `$schema` element, ",
      "adding `$schema` element for Vega-Lite major-version"
    )
    x <- c(`$schema` = vega_schema(), x)
  }

  # determine if this is a vega or vega_lite spec
  library <- .schema_type(x[["$schema"]])$library

  class_library <- paste0("vegaspec_", library)

  subclass <- NULL
  if (identical(class_library, "vegaspec_vega_lite")) {
    subclass <- .get_subclass(x)
  }

  class_new <- unique(c(subclass, class_library, "vegaspec", class(x)))

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
  jsonlite::toJSON(x, auto_unbox = TRUE, null = "null", pretty = pretty)
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

# Method for vegaspec
.find_urls <- function(spec){
  unlisted <- unlist(.as_list(spec), recursive = TRUE, use.names = TRUE)
  url_ix <- grep("^(.*[[:punct:]])*url$", names(unlisted))
  urls <- unname(unlisted[url_ix])
  urls
}

# spec has to be a (nascent) vegaspec
.get_subclass <- function(spec) {

  # subclasses: vegaspec_unit, vegaspec_layer, vegaspec_facet, vegaspec_repeat,
  #  vegaspec_concat, vegaspec_hconcat, vegaspec_vconcat
  names <- names(spec)

  if ("concat" %in% names) {
    return("vegaspec_concat")
  }

  if ("hconcat" %in% names) {
    return("vegaspec_hconcat")
  }

  if ("vconcat" %in% names) {
    return("vegaspec_vconcat")
  }

  if ("repeat" %in% names) {
    return("vegaspec_repeat")
  }

  if ("facet" %in% names) {
    return("vegaspec_facet")
  }

  if ("layer" %in% names) {
    return("vegaspec_layer")
  }

  return("vegaspec_unit")
}


