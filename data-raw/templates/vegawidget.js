// Please make sure you edit this file at data-raw/templates/vegawidget.js
//  - then render data-raw/infrastructure.Rmd

HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var view_promise = null;

    return {

      renderValue: function(x) {

        // initialise promise
        view_promise = vegaEmbed(el, x.chart_spec, opt = x.embed_options);

        // fulfill promise by rendering the visualisation
        view_promise
          .then(function(result) {
            // By removing the style (width and height) of the
            // enclosing element, we let the "chart" decide the space it
            // will occupy.
            el.removeAttribute("style");
          })
          .catch(console.error);
      },

      resize: function(width, height) {

      },

      // the view can just be an attribute of the HTMLWidgets object
      getView: view_promise,

      callView: function(fn, params) {
        view_promise.then(function(result) {
            let method = result[fn];
            method.apply(result, params);
            result.run();
          });
      },

      // hard reset of data to the view
      changeView: function(params) {
        let changeset = vega.changeset()
                            .remove(() => {return true})
                            .insert(params.data);
        let args = [params.name, changeset];
        this.callView('change', args);
      },


      addEventListener: function(event_name, handler) {
         view_promise.then(function(result) {
           result.addEventListener(event_name, handler);
         });
      },

      addSignalListener: function(signal_name, handler) {
        view_promise.then(function(result) {
          result.addSignalListener(signal_name, handler);
        });
      }
    };

  }
});


// Helper function to get view object via the htmlWidgets object
function getVegaView(selector){
  // Get the HTMLWidgets object
  let htmlWidgetsObj = HTMLWidgets.find(selector);
  console.log(htmlWidgetsObj);
  let noView = typeof htmlWidgetsObj === "undefined" | htmlWidgetsObj === null;

  return noView ? null : htmlWidgetsObj.getView;
}

if (HTMLWidgets.shinyMode) {
Shiny.addCustomMessageHandler('callView', function(message){

    // get the correct HTMLWidget instance
    var htmlWidgetsObj = HTMLWidgets.find("#" + message.id);
    if( typeof(htmlWidgetsObj) !== "undefined"){
      htmlWidgetsObj.callView(message.fn, message.params);
    }

});
}
