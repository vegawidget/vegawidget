#' Example vegaspec: mtcars scatterplot
#'
#' A Vega-Lite specification to create a scatterplot for `mtcars`.
#'
#' @format S3 object of class `vegaspec`
#' @seealso [as_vegaspec()]
#'
"spec_mtcars"


#' Example dataset: Seattle daily weather
#'
#' This dataset contains daily weather-observations from Seattle for the
#' years 2012-2015, inclusive.
#'
#' @format A data frame with 1461 observations of six variables
#' \describe{
#'   \item{date}{`Date`, date of the observation}
#'   \item{precipitation}{`double`, amount of precipitation (mm)}
#'   \item{temp_max}{`double`, maximum temperature (°C)}
#'   \item{temp_min}{`double`, minimum temperature (°C)}
#'   \item{wind}{`double`, average wind-speed (m/s)}
#'   \item{weather}{`character`, description of weather}
#' }
#' @source \url{https://vega.github.io/vega-datasets/data/seattle-weather.csv}
#'
"data_seattle_daily"

#' Example dataset: Seattle hourly temperatures
#'
#' This dataset contains hourly temperature observations from Seattle for the
#' year 2010.
#'
#' @format A data frame with 8759 observations of two variables
#' \describe{
#'   \item{date}{`POSIXct`, instant of the observation, uses `"America/Los_Angeles"`}
#'   \item{temp}{`double`, temperature (°C)}
#' }
#' @source \url{https://vega.github.io/vega-datasets/data/seattle-temps.csv}
#'
"data_seattle_hourly"

#' Example dataset: Categorical data
#'
#' This is a toy dataset; the numbers are generated randomly.
#'
#' @format A data frame with ten observations of two variables
#' \describe{
#'   \item{category}{`character`, representative of a nominal variable}
#'   \item{number}{`double`, representative of a quantitative variable}
#' }
#'
"data_category"
