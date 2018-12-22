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
      ),
      p(
        "Also, it might be nice to figure out some sort of",
        "hover-handler that could be used to change the cursor",
        "into a pointer (hand with finger) whenever the cursor",
        "covers a mark."
      )
    ),
    mainPanel(
      vegawidgetOutput("chart"),
      h4("Data returned as a result of signal"),
      verbatimTextOutput("signal_out")
    )
  )
)
