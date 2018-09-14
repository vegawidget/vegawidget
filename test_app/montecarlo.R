library(vegawidget)

est_pi <- function(n) {
  tibble::tibble(
    x = runif(n),
    y = runif(n),
    inside = (x^2 + y^2) <= 1,
    n = seq_len(n)) %>%
    dplyr::mutate(running_estimate = 4 * cumsum(inside) / n)
}


ui <- shiny::fluidPage(
  shiny::titlePanel("Monte-Carlo"),
  vegawidgetOutput("chart"),
  shiny::sliderInput("n", "n", min = 1, value = 100,
                     max = 5000, step = 1, sep = "")
)

server <- function(input, output, session) {
  set.seed(42)

  points <- list(
    data = list(name = "points"),
    width = 400,
    height = 400,
    mark = "circle",
    encoding = list(
      x = list(field = "x", type =  "quantitative", domain = c(0,1)),
      y = list(field = "y", type =  "quantitative", domain = c(0,1)),
      color = list(condition = list(test = "datum.inside", value = "#003f5c"),
                   value = "#ffa600")
    )
  )

  estimates <- list(width =  400,
                    height = 400,
                    `$schema` = vega_schema(),
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
                  hconcat = c(points, estimates))
  points_df <- est_pi(100)

  output$chart <- renderVegawidget(
    vegawidget(spec) %>%
      vw_load_data("points", points_df)
  )

  observe({
    if (nrow(points_df) > input$n) {
      points_df <<- dplyr::slice(points_df, 1L:input$n)
    } else if (nrow(points_df) < input$n) {
      n <- input$n - nrow(points_df)
      points_df <<- dplyr::bind_rows(points_df, est_pi(n))
    }

    vw_change_data("chart", "points", points_df)
  })

}

shiny::shinyApp(ui, server)
