// Please make sure you edit this file at data-raw/templates/vegawidget.js
//  - then render data-raw/infrastructure.Rmd

HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    var vega_promise = null;

    return {

      renderValue: function(x) {

        // initialise promise
        vega_promise = vegaEmbed(el, x.chart_spec, opt = x.embed_options);

        // fulfill promise by rendering the visualisation
        vega_promise
          .then(function(result) {
            // By removing the style (width and height) of the
            // enclosing element, we let the "chart" decide the space it
            // will occupy.
            // el.setAttribute("style", "");
            // console.log(el);
          })
          .catch(console.error);
      },

      // need to confront this at some point
      resize: function(width, height) {},

      // public function to get promise
      getPromise: function() {
        return vega_promise;
      },

      // generic function to call functions, a bit like R's do.call()
      callView: function(fn, params) {
        vega_promise.then(function(result) {
          var method = result.view[fn];
          method.apply(result.view, params);
          result.view.run();
        });
      },

      // Data functions

      // hard reset of data to the view
      changeView: function(params) {
        var changeset = vega.changeset()
                            .remove(function() {return true})
                            .insert(params.data);
        var args = [params.name, changeset];
        this.callView('change', args);
      },

      // TODO: the expected form of the data is different here than in the
      // changeView function
      loadData: function(name, data) {
        vega_promise.then(function(result) {
          result.view.insert(name, HTMLWidgets.dataframeToD3(data)).run();
        });
      },

      // Listener functions

      addEventListener: function(event_name, handler) {
        vega_promise.then(function(result) {
          result.view.addEventListener(event_name, handler);
        });
      },

      addSignalListener: function(signal_name, handler) {
        vega_promise.then(function(result) {
          result.view.addSignalListener(signal_name, handler);
        });
      },

      type: "vegawidget"

    };

  }
});


if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler('callView', function(message) {

    // we expect `message` to have properties: `id`, `fn`, `params`

    // get the Vegawidget object
    var vwObj = Vegawidget.find("#" + message.id);

    // verify we got a valid object
    if (vwObj !== null) {
       // the change call is a little different
       if (message.fn === "change") {
          vwObj.changeView(message.params);
       } else {
          vwObj.callView(message.fn, message.params);
       }
    }


  });

}

var Vegawidget = {

  // goal: get this to return a promise
  find: function(selector) {

    // find the element in the document
    var vwEl = document.querySelector(selector);

    // finds the html-widget object
    var vwObj = HTMLWidgets.find(selector);

    // determine existance of vwObj;
    var exists = vwObj !== undefined;
    if (!exists) {
      console.log("Cannot find vegawidget using selector: " + selector);
      console.log("This can happen if shiny calls too early");
      return(null);
    }

    // determine validity of vwObj;
    var valid = vwObj.hasOwnProperty("type") && vwObj.type === "vegawidget";
    if (!valid) {
      console.log("Object found using selector: " + selector + "is not a vegawidget");
      return(null);
    }

    return(vwObj);

  }

};
