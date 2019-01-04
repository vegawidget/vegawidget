library("shiny")
library("vegawidget")

ui_slider_bin_width <-
  sliderInput(
    "bin_witdh",
    label = "bin-width magnification (base 10)",
    min = -1,
    max = 1,
    value = 0,
    step = 0.01,
    animate = TRUE
  )

ui <- fluidPage(
  titlePanel("Vegawidget: setting and getting signals"),
  sidebarLayout(
    sidebarPanel(
      ui_slider_bin_width
    ),
    mainPanel(
      h4("Value of bin-width from input"),
      verbatimTextOutput("bin_width_in"),
      vegawidgetOutput("chart"),
      h4("Value of bin-width from chart"),
      verbatimTextOutput("bin_width_out")
    )
  )
)
