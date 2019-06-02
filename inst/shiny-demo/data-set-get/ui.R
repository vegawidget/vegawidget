library("shiny")
library("vegawidget")

ui_slider_angle <-
  sliderInput(
    "angle",
    label = "angle (°)",
    min = 0,
    max = 360,
    value = 0,
    animate = TRUE
  )

ui <- fluidPage(
  titlePanel("Vegawidget: setting data"),
  sidebarLayout(
    sidebarPanel(
      ui_slider_angle
    ),
    mainPanel(
      h4("Data sent to chart"),
      verbatimTextOutput("data_in"),
      vegawidgetOutput("chart"),
      h4("Data received from chart"),
      verbatimTextOutput("data_out")
    )
  )
)
