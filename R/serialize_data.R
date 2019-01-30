#' Serialize data-frame time-columns
#'
#' **Please think of this as an experimental function**
#'
#' In Vega, for now, there are only two time-zones available: the local
#' time-zone of the browser where the spec is rendered, and UTC. This differs
#' from R, where a time-zone attribute is available to `POSIXct` vectors.
#' Accordingly, when designing a vegaspec that uses time, you have to make some
#' some compromises. This function helps you to implement your compromise in
#' a principled way, as explained in the opinions below.
#'
#' Let's assume that your `POSIXct` data has a time-zone attached.
#' There are three different scenarios for rendering this data:
#'
#'  - using the time-zone of the browser
#'  - using UTC
#'  - using the time-zone of the data
#'
#'  If you intend to display the data using the **time-zone of the browser**,
#'  or using **UTC**, you should serialize datetimes using ISO-8601, i.e.
#'  `iso_dttm = TRUE`. In the rest of your vegaspec, you should choose
#'  local or UTC time-scales accordingly. However, in either case, you should
#'  use local time-units. No compromise is necessary.
#'
#'  If you intend to display the data using the **time-zone of the browser**,
#'  this is where you will have to compromise. In this case, you should
#'  serialize using `iso_dttm = FALSE`. By doing this, your datetimes will be
#'  serialized using a non-ISO-8601 format, and notably, **using the time-zone**
#'  of the datetime. When you design your vegaspec, you should treat this as
#'  if it were a UTC time. You should direct Vega to parse this data as UTC,
#'  i.e. `{"foo": "utc:'%Y-%m-%d %H:%M:%S'"}`. In other words, Vega should
#'  interpret your local timestamp as if it were a UTC timestamp.
#'  As in the first UTC case, you should use UTC time-scales and local
#'  time-units.
#'
#'  The compromise you are making is this: the internal representation of
#'  the instants in time will be different in Vega than it will be in R.
#'  You are losing information because you are converting from a `POSIXct`
#'  object with a time-zone to a timestamp without a time-zone. It is also
#'  worth noting that the time information in your Vega plot should not
#'  be used anywhere else - this should be the last place this serialized
#'  data should be used because it is no longer trustworthy. For this,
#'  you will gain the ability to show the data in the context of its
#'  time-zone.
#'
#'  Dates can be different creatures than datetimes. I think that can be
#'  "common currency" for dates. I think this is because it is more common to
#'  compare across different locations using dates as a common index. For
#'  example, you might compare daily stock-market data from NYSE, CAC-40, and
#'  Hang Seng. To maintain a common time-index, you might choose UTC to
#'  represent the dates in all three locations, despite the time-zone
#'  differences.
#'
#'  This is why the default for `iso_date` is `TRUE`. In this scenario,
#'  you need not specify to Vega how to parse the date; because of its
#'  ISO-8601 format, it will parse to UTC. As with the other UTC cases,
#'  you should use UTC time-scales and local time-units.
#'
#' @param data     `data.frame`, data to be serialized
#' @param iso_dttm `logical`, indicates if datetimes (`POSIXct`) are to be
#'   formatted using ISO-8601
#' @param iso_date `logical`, indicates if dates (`Date`) are to be
#'   formatted using ISO-8601
#'
#' @return object with the same type as `data`
#' @seealso [Vega-Lite Time Unit (UTC)](https://vega.github.io/vega-lite/docs/timeunit.html#utc)
#' @examples
#'   # datetimes
#'   data_seattle_hourly %>% head()
#'   data_seattle_hourly %>% head() %>% vw_serialize_data(iso_dttm = TRUE)
#'   data_seattle_hourly %>% head() %>% vw_serialize_data(iso_dttm = FALSE)
#'
#'   # dates
#'   data_seattle_daily %>% head()
#'   data_seattle_daily %>% head() %>% vw_serialize_data(iso_date = TRUE)
#'   data_seattle_daily %>% head() %>% vw_serialize_data(iso_date = FALSE)
#'
#' @export
#'
vw_serialize_data <- function(data, iso_dttm = FALSE, iso_date = TRUE) {

  dttm_format <- function(x, iso) {

    # if not a datetime, return unchanged
    if (!inherits(x, "POSIXt")) {
      return(x)
    }

    # is a datetime, format according to iso
    if (iso) {
      x <- format(x, format = "%Y-%m-%dT%H:%M:%OS3Z", tz = "UTC")
    } else {
      x <- format(x, format = "%Y-%m-%d %H:%M:%OS3")
    }

    x
  }

  date_format <- function(x, iso) {

    # if not a Date, return unchanged
    if (!inherits(x, "Date")) {
      return(x)
    }

    # is a Date, format according to iso
    if (iso) {
      x <- format(x, format = "%Y-%m-%d")
    } else {
      x <- format(x, format = "%Y/%m/%d")
    }

    x
  }

  cols <- colnames(data)

  data[cols] <- lapply(data[cols], dttm_format, iso = iso_dttm)
  data[cols] <- lapply(data[cols], date_format, iso = iso_date)

  data
}
