library("shiny")
library("vegawidget")
library("dplyr")
library("tibble")

set.seed(314159)


# datasets

n_row <- 10
source_a <- tibble(
  category = letters[1:n_row],
  amount = round(runif(n_row), 3)
)

# similar to data_a, missing only the last row
source_b <- data_a %>% slice(-n_row)

# completely different from data_a
source_c <- tibble(
  category = letters[1:n_row],
  amount = round(runif(n_row), 3)
)

# vegalite spec
spec <-
  list(
    `$schema` = vega_schema(),
    data = list(name = "source"),
    mark = "bar",
    encoding = list(
      x = list(field = "category", type = "ordinal"),
      y = list(field = "amount", type = "quantitative")
    )
  )


list_data <- list(a = source_a, b = source_b, c = source_c)

ui <- fluidPage(
  titlePanel("vegawidget data"),
  fluidRow(
    selectInput(
      "dataset",
      label = "dataset",
      choices = c(
        "A (similar)" = "a",
        "B (similar)" = "b",
        "C (different)" = "c"
      )
    )
  ),
  fluidRow(verbatimTextOutput("data_text")),
  fluidRow(vegawidgetOutput("chart"))
)

server <- function(input, output) {

  # reactives
  rct_data <- reactive(list_data[[input$dataset]])

  # observers
  observe({
    print("hello")
    print(names(input))
  })

  # TODO: note that use_cache = TRUE does not yet work
  vw_shiny_set_data(rct_data(), output_id = "chart", name = "source", use_cache = FALSE)

  # outputs
  output$chart <- renderVegawidget(vegawidget(spec))

  output$data_text <- renderPrint(glimpse(rct_data()))

}

# Run the application
shiny::shinyApp(ui = ui, server = server)
