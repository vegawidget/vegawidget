spec_histogram <-
  list(
    `$schema` = vega_schema(),
    width = 300,
    height = 300,
    usermeta = list(
      vegawidget = list(
        signals = list(
          list(name = "bin_width", value = 5)
        )
      )
    ),
    data = list(values = data_seattle_hourly),
    mark = "bar",
    encoding = list(
      x = list(
        field = "temp",
        type = "quantitative",
        bin = list(step = list(signal = 5)),
        axis = list(format = ".1f")
      ),
      y = list(
        aggregate = "count",
        type = "quantitative"
      )
    )
  ) %>%
  as_vegaspec()
