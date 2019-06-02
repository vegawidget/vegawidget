This example shows how we can design a chart using Vega-Lite, then use Shiny to run that chart, varying the data. The example uses a dataset with a single observation, a point constrained to the unit-circle. The angle of the point is controlled with a slider-input.

In the server function, we create a reactive data-frame, `rct_data()` that converts the angle-input into a set of coordinates. We use `vw_shiny_set_data()`, which acts as a Shiny observer, to update the chart's dataset in response to changes in the reactive expression `rct_data()`. To do this, we had to name the dataset in the Vega-Lite specification; you will see in the definition of `spec_circle` that there is a dataset named `"source"`. We use this as the `name` argument for `vw_shiny_set_data()`.

Also in the server function, we have a function `vw_shiny_get_data()`, which acts as a Shiny reactive that returns a `data.frame`. We supply this function with the `name` of the dataset in the chart; Vega and Shiny will supply new values of the dataset as it changes in the Vega chart.


