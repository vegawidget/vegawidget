This example shows how we can design a chart using Vega-Lite, then use Shiny to run that chart using different datasets. Also, it shows how we can update the data to a chart and delay re-running that chart until we tell it to re-run.

In the server function, we use `vw_shiny_set_data()` to observe the reactive expression `rct_data()`, updating the dataset, then re-running the Vega-Lite chart, whenever `rct_data()` changes.

To do this, we had to name the dataset in the Vega-Lite specification; you will see in the definition of `spec_bar` that there is a dataset named `"source"`. We use this as the `name` argument for `vw_shiny_set_data()`.

To delay re-running the chart when the data is updated, we call `vw_shiny_set_data()` with `run = FALSE`. This leaves us with the need for a mechanism to run the chart. 

We do this using the function `vw_shiny_run()`, which observes the reactive expression linked to the `shiny::actionButton()` we create.
