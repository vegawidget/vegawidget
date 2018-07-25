HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var view = null;
    var event_listeners = {};
    var signal_listeners = {};
    var svg_result = null;

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

          for (var event_name in event_listeners) {
            result.view.addEventListener(event_name, event_listeners[event_name]);
          }

          for (var signal_name in signal_listeners) {
            result.view.addSignalListener(signal_name, signal_listeners[signal_name]);
          }


        }).catch(console.error);

      },

      resize: function(width, height) {

      },

      getView: function() {
        return view;
      },


      callView: function(fn, params) {
        if (view !== null && view !== undefined){
          var method = view[fn];
          method.apply(view, params);
          view.run();
        }
      },

      addEventListener: function(event_name, handler) {
         console.log(event_name);
         console.log(handler);
         event_listeners[event_name] = handler;
      },

      addShinyEventListener: function(event_name) {
        if (HTMLWidgets.shinyMode) {
          event_listeners[event_name] =
            function(event, item) {
              if (item !== null && item !== undefined && item.datum !== undefined){
                Shiny.onInputChange(el.id + "_" + event_name, item.datum);
              } else {
                Shiny.onInputChange(el.id + "_" + event_name,null);
              }
            };
         }
      },

      addSignalListener: function(signal_name, handler) {
         signal_listeners[signal_name] = handler;
      },

      addShinySignalListener: function(signal_name) {
        if (HTMLWidgets.shinyMode) {
          signal_listeners[signal_name] =
            function(name, value) {
              Shiny.onInputChange(el.id + "_" + signal_name, value);
            };
         }
      }

    };


  }
});


// Helper function to get view object via the htmlWidgets object
function getVegaView(id){

  // Get the HTMLWidgets object
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  console.log(htmlWidgetsObj);
  var view_obj = null;

  if( typeof(htmlWidgetsObj) !== "undefined"){
    view_obj = htmlWidgetsObj.getView();
  }

  return(view_obj);
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


/*if (HTMLWidgets.shinyMode) {
  var fxns = ['vegawidget_event_listener'];

  var addShinyHandler = function(fxn) {
    return function() {
      Shiny.addCustomMessageHandler(
        "vegawidget:" + fxn, function(message) {
          var el = document.getElementById(message.id);
          console.log(message.id);
          console.log(el.widget);
          if (el) {
            el.widget[fxn](message);
          }
        }
      );
    };
  };

  for (var i = 0; i < fxns.length; i++) {
    addShinyHandler(fxns[i])();
  }
}*/
