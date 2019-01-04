This example shows how we can design a chart using Vega-Lite, then use Shiny to return the data behind a graphical mark when that mark is clicked, by directing Vega to listen to `"click"` events.

In the server function, we use `vw_shiny_get_event()` to return the data behind a mark, whenever that mark is clicked. We specify that the `event` to be listened-to is `"click"`. We also have to tell Vega what to do when it receives a click-event; we do this using a JavaScript event-handler.

To make things a little bit easier, this package provides a handler-library, so you can specify to use the `"datum"` handler, which returns a list of the data-observation (datum) associated with the current location of the cursor. You need only specify the body of a function that returns the value that you want sent Shiny, the `vw_shiny_get_event()` function takes care of the rest of the JavaScript.  



