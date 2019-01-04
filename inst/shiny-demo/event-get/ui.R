library("shiny")
library("vegawidget")

ui <- fluidPage(
  titlePanel("Vegawidget: getting data from events"),
  sidebarLayout(
    sidebarPanel(
      p("Click on a mark on the chart to return the backing-data."),
      p(
        "For some unknown reason, for the event-handling to work",
        "when the app is in display-mode, the code has to appear",
        "underneath the rest of the app."
      )
    ),
    mainPanel(
      vegawidgetOutput("chart"),
      h4("Data returned as a result of event"),
      verbatimTextOutput("event_out")
    )
  )
)
