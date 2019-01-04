This example shows how we can design a chart using Vega-Lite, then use Shiny to return the data behind a graphical mark when that mark is clicked.

In the server function, we use `vw_shiny_get_event()` to return the data behind a mark, whenever that mark is clicked. We specify the `event` to be `"click"`, we use the `handler` that returns the `"datum"` (row of data); this is returned as a reactive expression.


