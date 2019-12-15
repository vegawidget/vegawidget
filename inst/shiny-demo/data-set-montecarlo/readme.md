This example, based on an [example from Cameron Yick](https://observablehq.com/@hydrosquall/monte-carlo-pi-approximation-explorable-explanation-in-ve), shows how we can design a chart using Vega-Lite, then use Shiny to run that chart using a dataset that can be updated. 

In the server function, we use `vw_shiny_set_data()` to observe the reactive expression `rct_points()`, updating the datasets, then re-running the Vega-Lite chart, whenever `rct_points()` changes.

To do this, we had to name the datasets in the Vega-Lite specification; you will see in the definition of `spec` that there are datasets named `"points"` and `"estimates"`. We use these as `name` arguments for `vw_shiny_set_data()`.

