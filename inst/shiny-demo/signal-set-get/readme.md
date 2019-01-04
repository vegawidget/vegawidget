This example shows how we can design a chart using Vega-Lite, then use Shiny to set a signal and retrieve its value from the chart. This example shows a histogram with a Shiny input to control the bin-width; we communicate the bin-width to the chart using a [signal](https://vega.github.io/vega/docs/signals).

The difference between using a signal and re-creating the chart in the `server()` function is that by using the signal, the chart is recalculated by Vega, in the client browser. Instead of communicating an entire chart-specification (including data) upon each change, Shiny has to communicate only a single number, the bin-width.

Signals are not a part of the Vega-Lite definition, so we have to "hack" a signal into our Vega-Lite chart, then patch the compiled Vega specification using the `patch` option in `vega_embed()`. This follows an [Observable example](https://beta.observablehq.com/@domoritz/rotating-earth) written by Vega-Lite developer Dominik Moritz. As of the start of 2019, the integration of signals in to the Vega-Lite definition is an [ongoing discussion](https://github.com/vega/vega-lite/issues/3338).

In the server function, we use a couple of functions to set the signal value in the chart, and to get the signal value from the chart:

- to update the chart by **setting** the signal, we use the function `vw_shiny_set_signal()`, which acts as a Shiny observer because it produces the side-effect of changing the chart.

- to **get** the value of the signal from the chart, we use the function `vw_shiny_get_signal()`, which acts as a Shiny reactive. It returns a Shiny reactive-function that evaluates to the value of the signal.



