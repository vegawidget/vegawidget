Sample datasets
================

``` r
library("readr")
library("tibble")
library("lubridate")
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library("magrittr")
library("vegawidget")
```

## Categorical data

``` r
set.seed(314159)
n_cat <- 10

data_category <- 
  tibble(
    category = letters[seq(n_cat)],
    number = as.integer(runif(n_cat) * 100)
  ) %>%
  glimpse()
```

    ## Rows: 10
    ## Columns: 2
    ## $ category <chr> "a", "b", "c", "d", "e", "f", "g", "h", "i", "j"
    ## $ number   <int> 21, 64, 23, 41, 92, 52, 61, 27, 34, 48

## Daily data

This data is taken from the
[vega-datasets](https://github.com/vega/vega/tree/master/docs/data)
repository. For this dataset, the source is NOAA.

``` r
data_seattle_daily <- 
  read_csv("https://vega.github.io/vega-datasets/data/seattle-weather.csv")
```

    ## Rows: 1461 Columns: 6

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (1): weather
    ## dbl  (4): precipitation, temp_max, temp_min, wind
    ## date (1): date

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

## Hourly data

``` r
data_seattle_hourly <- 
  read_csv("https://vega.github.io/vega-datasets/data/seattle-weather-hourly-normals.csv") %>%
  glimpse()
```

    ## Rows: 8759 Columns: 4

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (3): pressure, temperature, wind
    ## dttm (1): date

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 8,759
    ## Columns: 4
    ## $ date        <dttm> 2010-01-01 01:00:00, 2010-01-01 02:00:00, 2010-01-01 03:0…
    ## $ pressure    <dbl> 1016.6, 1016.6, 1016.7, 1016.7, 1016.5, 1016.4, 1016.5, 10…
    ## $ temperature <dbl> 4.0, 3.9, 3.8, 3.8, 3.7, 3.7, 3.7, 3.7, 4.0, 4.5, 5.2, 5.8…
    ## $ wind        <dbl> 3.8, 3.8, 3.8, 3.7, 3.8, 3.8, 3.9, 3.9, 3.9, 3.9, 3.9, 4.0…

``` r
# need to correct one of the times (this instant does not exist in local time)
data_seattle_hourly$date[data_seattle_hourly$date == "2010-03-14T02:00:00"] <-
  "2010-03-14T03:00:00"
  
data_seattle_hourly$date <- 
  parse_date_time(
    data_seattle_hourly$date, 
    orders = "%Y/%m/%d %H:%M:%S",
    tz = "America/Los_Angeles"
  )  
```

    ## Warning: 1 failed to parse.

``` r
data_seattle_hourly$temp <- data_seattle_hourly$temperature

data_seattle_hourly <- data_seattle_hourly[, c("date", "temp")]
```

``` r
glimpse(data_seattle_hourly)
```

    ## Rows: 8,759
    ## Columns: 2
    ## $ date <dttm> 2010-01-01 01:00:00, 2010-01-01 02:00:00, 2010-01-01 03:00:00, 2…
    ## $ temp <dbl> 4.0, 3.9, 3.8, 3.8, 3.7, 3.7, 3.7, 3.7, 4.0, 4.5, 5.2, 5.8, 6.2, …

## mtcars

The data are documented in `R/data.R`.

``` r
spec_mtcars <-
  as_vegaspec(
    list(
      `$schema` = "https://vega.github.io/schema/vega-lite/v5.json",
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

class(spec_mtcars)
```

    ## [1] "vegaspec_unit"      "vegaspec_vega_lite" "vegaspec"          
    ## [4] "list"

## Write it out

``` r
usethis::use_data(
  data_category,
  data_seattle_daily,
  data_seattle_hourly,
  spec_mtcars,
  overwrite = TRUE  
)
```

    ## ✓ Setting active project to '/Users/ijlyttle/Documents/repos/public/vegawidget/vegawidget'

    ## ✓ Saving 'data_category', 'data_seattle_daily', 'data_seattle_hourly', 'spec_mtcars' to 'data/data_category.rda', 'data/data_seattle_daily.rda', 'data/data_seattle_hourly.rda', 'data/spec_mtcars.rda'

    ## • Document your data (see 'https://r-pkgs.org/data.html')
