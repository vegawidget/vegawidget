This example shows how we can design a chart using Vega-Lite, then use Shiny to run that chart using a dataset that can be updated. 

In the server function, we use `vw_shiny_set_data()` to observe the reactive expression `rct_data_year()`, updating the dataset, then re-running the Vega-Lite chart, whenever `rct_data_year()` changes.

To do this, we had to name the dataset in the Vega-Lite specification; you will see in the definition of `spec` that the dataset is named `"source"`. We use this as the `name` argument for `vw_shiny_set_data()`.

