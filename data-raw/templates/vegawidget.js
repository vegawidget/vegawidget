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
      }

    };

  }
});


if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler('callView', function(message) {

    // we expect `message` to have properties: `id`, `fn`, `params`
    console.log('Shiny callView');
    console.log(message);

    // get the Vegawidget object
    var vwObj = Vegawidget.find("#" + message.id).then(function(result) {
       // the change call is a little different
       console.log(result);
       if (message.fn === "change") {
         result.changeView(message.params);
       } else {
         result.callView(message.fn, message.params);
       }
    });

  });

}

var Vegawidget = {

  // goal: get this to return a promise
  find: function(selector) {

    return new Promise(function(resolve, reject){

      // find and test the element in the document
      var vwEl = document.querySelector(selector);

      // element does not exist
      if (vwEl === null) {
        reject(
          console.log(
            "No document element found using selector " +
            "'" + selector + "'" +
            ".")
        );
      }

      // element is not a vegawidget
      if (!vwEl.classList.contains("vegawidget")) {
        reject(
          console.log(
            "Document element found using selector " +
            "'" + selector + "'" +
            " does not have class 'vegawidget'."
          )
        );
      }

      var vwObj = HTMLWidgets.find(selector);

     	if (vwObj !== undefined) {
    		resolve(vwObj);
    	} else {
    		setTimeout(function() { Vegawidget.find(selector).then(resolve); }, 50);
    	}

    });
  }

};
