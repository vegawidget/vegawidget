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

            /*result.view.addEventListener('mousemove', function(event, item) {
              d = view.getState();
              if (d !== null && d!== undefined && d.data !== undefined){
                Shiny.onInputChange(el.id + "_data", d.data);
              } else {
               Shiny.onInputChange(el.id + "_data",null);
              }
            });*/

            //result.view.addSignalListener('brush_tuple', function(name, value){
            //  console.log(value);
            //  Shiny.onInputChange("brush_selected", value);
            //});
            result.view.addEventListener('click', function(event, item) {
             if (item !== null && item !== undefined && item.datum !== undefined){
               Shiny.onInputChange(el.id + "_click",item.datum);
             } else {
               Shiny.onInputChange(el.id + "_click",null);
             }
            });
            result.view.addEventListener('mouseover', function(event, item) {
             if (item !== null && item !== undefined && item.datum !== undefined){
               Shiny.onInputChange(el.id + "_hover",item.datum);
             } else {
               Shiny.onInputChange(el.id + "_hover",null);
             }
            });
            result.view.addEventListener('dblclick', function(event, item) {
             if (item !== null && item !== undefined && item.datum !== undefined){
               Shiny.onInputChange(el.id + "_dblclick",item.datum);
             } else {
               Shiny.onInputChange(el.id + "_dblclick",null);
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
