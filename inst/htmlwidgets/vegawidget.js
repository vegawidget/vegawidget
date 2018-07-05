HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var view = null;

    return {

      renderValue: function(x) {

        var chart_spec = x.chart_spec;
        var embed_options = x.embed_options;

        vegaEmbed(el, chart_spec, opt = embed_options).then(function(result) {

          // By removing the style (width and height) of the
          // enclosing element, we let the "chart" decide the space it
          // will occupy.
          //
          el.removeAttribute("style");

          view = result.view;
          if (HTMLWidgets.shinyMode) {

            //result.view.addSignalListener('brush_tuple', function(name, value){
            //  console.log(value);
            //  Shiny.onInputChange("brush_selected", value);
            //});
            result.view.addEventListener('click', function(event, item) {
             console.log(item);
             if (item.datum !== undefined){
               Shiny.onInputChange(el.id + "_clicked",item.datum);
             } else {
               Shiny.onInputChange(el.id + "_clicked",null);
             }
          });
          }

        }).catch(console.error);

      },

      resize: function(width, height) {

      },

      view: view

    };
  }
});
