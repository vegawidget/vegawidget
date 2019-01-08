library("shiny")
library("tibble")
library("vegawidget")

spec_histogram <-
  list(
    `$schema` = vega_schema(),
    width = 300,
    height = 300,
    data = list(values = data_seattle_hourly),
    mark = "bar",
    encoding = list(
      x = list(
        field = "temp",
        type = "quantitative",
        # using a signal here is a "hack" that needs to be patched
        bin = list(step = list(signal = "bin_width")),
        axis = list(format = ".1f")
      ),
      y = list(
        aggregate = "count",
        type = "quantitative"
      )
    )
  ) %>%
  as_vegaspec()

# this will be patched into the compiled Vega specification
patch <-
  list(
    signals = list(
      list(name = "bin_width", value = 0.5)
    )
  )

# create the histogram, invoking the patch
histogram <- vegawidget(spec_histogram, embed = vega_embed(patch = patch))

server <- function(input, output) {

  ## reactives

  # sets the bin-width from the input
  rct_bin_width_in <- reactive({
    # baseline bin-width is 1 °F, can go up-or-down a decade
    1. * 10^(input$bin_witdh)
  })

  # the signal returns the bin-width from the chart
  rct_bin_width_out <-
    vw_shiny_get_signal("chart", name = "bin_width", body_value = "value")

  ## observers

  # this sets the bin-width signal in the chart
  vw_shiny_set_signal("chart", name = "bin_width", value = rct_bin_width_in())

  ## outputs

  # bin-width from input
  output$bin_width_in <- renderPrint({
    round(rct_bin_width_in(), 3L)
  })

  # histogram
  output$chart <- renderVegawidget(histogram)

  # bin-width from chart
  output$bin_width_out <- renderPrint({
    # protects against initial NULL
    rct_bin_width_out() %>% as.numeric() %>% round(3L)
  })

}
