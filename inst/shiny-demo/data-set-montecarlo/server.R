library("shiny")
library("dplyr")
library("tibble")
library("vegawidget")

set.seed(42)

# function to create a dataset based on number of points
sample_uc <- function(n) {
  tibble::tibble(
    x = runif(n),
    y = runif(n),
    inside = (x^2 + y^2) <= 1
  )
}

# function to create a dataset with a running estimate of
#  pi, based on the dataset from the previous function
est_pi <- function(.data) {
  .data %>%
    dplyr::transmute(
      n = seq_len(n()),
      running_estimate = 4 * cumsum(inside) / n,
      inside
    )
}

# create chart-specification
dim_chart <- 225

# this will show each x-y points, colored according to
# its presence inside the unit circle
points <-
  list(
    data = list(name = "points"),
    width = dim_chart,
    height = dim_chart,
    mark = "circle",
    encoding = list(
      x = list(
        field = "x",
        type = "quantitative",
        scale = list(domain = c(0, 1))
      ),
      y = list(
        field = "y",
        type = "quantitative",
        scale = list(domain = c(0, 1))
      ),
      color = list(field = "inside", type = "nominal")
    )
  )

# this will show a running estimate of the value of pi
estimates <-
  list(
    width = dim_chart,
    height = dim_chart,
    data = list(name = "estimates"),
    layer = list(
      list(
        data = list(values = list(pi = pi)),
        mark = "rule",
        encoding = list(
          y = list(field = "pi", type = "quantitative"),
          opacity = list(value = 0.5),
          color = list(value = "black")
        )
      ),
      list(
        mark = list(type = "circle", clip = TRUE),
        encoding = list(
          x = list(
            field = "n",
            type = "quantitative",
            axis = list(title = "Number of points")
          ),
          y = list(
            field = "running_estimate",
            type = "quantitative",
            scale = list(domain = c(2, 4)),
            axis = list(title = "Estimate of pi")
          ),
          color = list(field = "inside", type = "nominal"),
          size = list(value = 8)
        )
      )
    )
  )

spec <-
  list(
    `$schema` = vega_schema(),
    hconcat = list(points, estimates)
  ) %>%
  as_vegaspec()

# create all the data
#  - we will choose how much of it to send to the chart
data_points_all <- sample_uc(5000)

server <- function(input, output) {

  # reactives
  #

  # keep a portion of the dataset, according to the input
  rct_points <- reactive({
    data_points_all %>% slice(1L:input$n_points)
  })

  # observers
  #

  # update the datasets in the chart
  vw_shiny_set_data("chart", "points", rct_points())
  vw_shiny_set_data("chart", "estimates", est_pi(rct_points()))

  # outputs
  #
  output$chart <- renderVegawidget(spec)
}
