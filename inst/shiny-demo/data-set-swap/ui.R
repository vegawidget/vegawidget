library("shiny")
library("vegawidget")

ui_select_dataset <-
  selectInput(
    "dataset",
    label = "dataset",
    choices = c(
      "A (similar)" = "a",
      "B (similar)" = "b",
      "C (different)" = "c"
    )
  )

ui <- fluidPage(
  titlePanel("Vegawidget: setting data"),
  sidebarLayout(
    sidebarPanel(
      ui_select_dataset
    ),
    mainPanel(
      h4("Data sent to chart"),
      verbatimTextOutput("data_in"),
      vegawidgetOutput("chart")
    )
  )
)
