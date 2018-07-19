HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var view = null;

    if (HTMLWidgets.shinyMode) {
          Shiny.onInputChange(el.id + "_view", null);
    }

    var event_listeners = {};

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

          for (var event_name in event_listeners){
            console.log(event_listeners[event_name]);
            result.view.addEventListener(event_name, event_listeners[event_name]);
          }

          if (HTMLWidgets.shinyMode) {
            //Shiny.onInputChange(el.id + "_view", null);

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
            /*result.view.addEventListener('dragover', function(event, item) {
             console.log(item)
            });
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
            });*/
          }

        }).catch(console.error);

      },

      resize: function(width, height) {

      },

      getView: function() {
        return view;
      },

      callView: function(fn, params) {
        if (view !== null){
          view[fn].apply(this, params);
        }
      },

      addEventListener: function(event, handler) {
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
Shiny.addCustomMessageHandler('addEventListener', function(message){

    // get the correct HTMLWidget instance
    var view = getVegaView(message.id);
    if (view !== null) {
      console.log(message.handler);
      eval("callback = " + message.handler + ";");
      view.addEventListener(message.event, callback);
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
