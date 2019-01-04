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

ui_button_run <- actionButton("run", label = "Re-run chart")

ui <- fluidPage(
  titlePanel("Vegawidget: setting data with delayed run"),
  sidebarLayout(
    sidebarPanel(
      ui_select_dataset,
      ui_button_run
    ),
    mainPanel(
      h4("Data sent to chart"),
      verbatimTextOutput("data_in"),
      vegawidgetOutput("chart")
    )
  )
)
