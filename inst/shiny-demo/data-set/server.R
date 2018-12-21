library("shiny")
library("vegawidget")
library("tibble")

set.seed(314159)

# Create datasets
#
# We provide a list of three datasets: two of which have
# nearly-identical data; the other one will have different
# data. All three datasets will have the same format.
#
n_row <- 10
source_a <- tibble(
  category = letters[1:n_row],
  amount = round(runif(n_row), 3)
)

# nearly-identical to source_a, missing only the last row
source_b <- source_a[-c(n_row), ]

# completely different amounts than source_a
source_c <- tibble(
  category = letters[1:n_row],
  amount = round(runif(n_row), 3)
)

list_data <- list(a = source_a, b = source_b, c = source_c)

# Create vegaspec
#
spec_bar <-
  list(
    `$schema` = vega_schema(),
    data = list(name = "source"),
    mark = "bar",
    encoding = list(
      x = list(field = "category", type = "ordinal"),
      y = list(
        field = "amount",
        type = "quantitative",
        scale = list(domain = list(0, 1))
      )
    )
  ) %>%
  as_vegaspec()

server <- function(input, output) {

  # reactives
  #
  rct_data <- reactive(list_data[[input$dataset]])

  # observers
  #

  # whenever rct_data() changes, the chart will be updated
  vw_shiny_set_data("chart", name = "source", value = rct_data())

  # outputs
  #
  output$data_in <- renderPrint(glimpse(rct_data()))

  output$chart <- renderVegawidget(spec_bar)
}


