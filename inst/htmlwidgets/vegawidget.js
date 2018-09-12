// Please make sure you edit this file at data-raw/templates/vegawidget.js
//  - then render data-raw/infrastructure.Rmd

HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var view_promise = null;

    return {

      renderValue: function(x) {

        var chart_spec = x.chart_spec;
        var embed_options = x.embed_options;

        view_promise = vegaEmbed(el, chart_spec, opt = embed_options).then(function(result) {

          // By removing the style (width and height) of the
          // enclosing element, we let the "chart" decide the space it
          // will occupy.
          //
          el.removeAttribute("style");

          return(result.view);

        }).catch(console.error);

      },

      resize: function(width, height) {

      },

      getView: function() {
        return view_promise;
      },

      callView: function(fn, params) {
        view_promise.then(function(result) {
            var method = result[fn];
            method.apply(result, params);
            result.run();
          });
      },

      addEventListener: function(event_name, handler) {
         view_promise.then(function(result){ result.addEventListener(event_name, handler); });
      },

      addSignalListener: function(signal_name, handler) {
        view_promise.then(function(result){ result.addSignalListener(signal_name, handler); });
      }

    };

  }
});


// Helper function to get view object via the htmlWidgets object
function getVegaView(selector){

  // Get the HTMLWidgets object
  var htmlWidgetsObj = HTMLWidgets.find(selector);

  console.log(htmlWidgetsObj);
  var view_obj = null;

  if (typeof(htmlWidgetsObj) !== "undefined"){
    view_obj = htmlWidgetsObj.getView();
  }

  return(view_obj);
}

if (HTMLWidgets.shinyMode) {
Shiny.addCustomMessageHandler('callView', function(message){

    // get the correct HTMLWidget instance
    var htmlWidgetsObj = HTMLWidgets.find("#" + message.id);
    if( typeof(htmlWidgetsObj) !== "undefined"){
      if (message.fn === "change") {
        htmlWidgetsObj.changeView(message.params);
      } else {
        htmlWidgetsObj.callView(message.fn, message.params);
      }

    }

});
}
