Sample datasets
================

``` r
library("readr")
library("tibble")
library("lubridate")
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

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

    ## Observations: 10
    ## Variables: 2
    ## $ category <chr> "a", "b", "c", "d", "e", "f", "g", "h", "i", "j"
    ## $ number   <int> 21, 64, 23, 41, 92, 52, 61, 27, 34, 48

## Daily data

This data is taken from the [vega-datasets]() repository, which appears
to be unlicenced. For this dataset, the source is NOAA.

``` r
data_seattle_daily <- 
  read_csv("https://vega.github.io/vega-datasets/data/seattle-weather.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   date = col_date(format = ""),
    ##   precipitation = col_double(),
    ##   temp_max = col_double(),
    ##   temp_min = col_double(),
    ##   wind = col_double(),
    ##   weather = col_character()
    ## )

## Hourly data

``` r
data_seattle_hourly <- 
  read_csv("https://vega.github.io/vega-datasets/data/seattle-temps.csv") %>%
  glimpse()
```

    ## Parsed with column specification:
    ## cols(
    ##   date = col_character(),
    ##   temp = col_double()
    ## )

    ## Observations: 8,759
    ## Variables: 2
    ## $ date <chr> "2010/01/01 00:00", "2010/01/01 01:00", "2010/01/01 02:00",…
    ## $ temp <dbl> 39.4, 39.2, 39.0, 38.9, 38.8, 38.7, 38.7, 38.6, 38.7, 39.2,…

``` r
# need to correct one of the times (this instant does not exist in local time)
data_seattle_hourly$date[data_seattle_hourly$date == "2010/03/14 02:00"] <-
  "2010/03/14 03:00"
  
data_seattle_hourly$date <- 
  parse_date_time(
    data_seattle_hourly$date, 
    orders = "%Y/%m/%d %H:%M",
    tz = "America/Los_Angeles"
  )  
```

``` r
glimpse(data_seattle_hourly)
```

    ## Observations: 8,759
    ## Variables: 2
    ## $ date <dttm> 2010-01-01 00:00:00, 2010-01-01 01:00:00, 2010-01-01 02:00…
    ## $ temp <dbl> 39.4, 39.2, 39.0, 38.9, 38.8, 38.7, 38.7, 38.6, 38.7, 39.2,…

## Mtcars

The data are documented in `R/data.R`.

``` r
spec_mtcars <-
  as_vegaspec(
    list(
      `$schema` = "https://vega.github.io/schema/vega-lite/v3.json",
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

    ## ✔ Setting active project to '/Users/sesa19001/Documents/repos/public/vegawidget/vegawidget'
    ## ✔ Saving 'data_category', 'data_seattle_daily', 'data_seattle_hourly', 'spec_mtcars' to 'data/data_category.rda', 'data/data_seattle_daily.rda', 'data/data_seattle_hourly.rda', 'data/spec_mtcars.rda'
