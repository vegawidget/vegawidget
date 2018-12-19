library(vegawidget)
library(dplyr)

sample_uc <- function(n) {
  tibble::tibble(
    x = runif(n),
    y = runif(n),
    inside = (x^2 + y^2) <= 1
  )
}

est_pi <- function(.data) {
  .data %>%
    transmute(n = seq_len(n()),
           running_estimate = 4 * cumsum(inside) / n)
}

set.seed(42)

points <- list(
  data = list(name = "points"),
  width = 400,
  height = 400,
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
    color = list(condition = list(test = "datum.inside", value = "#003f5c"),
                 value = "#ffa600")
  )
)

estimates <- list(width =  400,
                  height = 400,
                  data = list(name = 'estimates'),
                  mark = list(type = "circle", clip = TRUE),
                  encoding = list(
                    x = list(field = "n", type = "quantitative",
                             axis = list(title = "Number of Points")
                    ),
                    y = list(field = "running_estimate",
                             type = "quantitative",
                             scale = list(domain = c(2,4)),
                             axis = list(title = "Estimate")
                    ),
                    size = list(value = 8)
                  )
)

spec <- list( `$schema` = vega_schema(),
              hconcat = list(points, estimates))

data_all <- sample_uc(5000)

ui <- shiny::fluidPage(
  shiny::titlePanel("Monte-Carlo"),
  vegawidgetOutput("chart"),
  shiny::sliderInput("n", "n", min = 1, value = 100,
                     max = 5000, step = 1, sep = "", animate = TRUE)
)

server <- function(input, output, session) {

  # reactives
  rct_data <- reactive({
    data_all %>% slice(1L:input$n)
  })

  # observers
  vw_shiny_set_data("chart", "points", rct_data())
  vw_shiny_set_data("chart", "estimates", est_pi(rct_data()))

  # outputs
  output$chart <- renderVegawidget(
    vegawidget(spec)
  )
}

shiny::shinyApp(ui, server)
