// Please make sure you edit this file at data-raw/templates/vegawidget.js
//  - then render data-raw/infrastructure.Rmd

HTMLWidgets.widget({

  name: "vegawidget",

  type: "output",

  factory: function(el, width, height) {

    // private stuff
    var view_promise = null;

    var processData = function(data) {

      // if this is a string, construct a function
      if (typeof(data) === "string") {
        // Q: what are the risks of this?
        return(new Function("data_remove", data));
      }

      // if data is column-based, convert to row-based
      if (typeof(data) === "object" && !Array.isArray(data)) {
        return(HTMLWidgets.dataframeToD3(data));
      }

      // assuming this is already row-based, no-op: return data
      return(data);
    };

    return {

      // x, object to instantitate htmlwidget
      renderValue: function(x) {

        // initialise promise
        view_promise =
          vegaEmbed(el, x.chart_spec, opt = x.embed_options)
            .then(function(result) {
              return result.view;
            });

        // fulfill promise by rendering the visualisation
        view_promise
          .then(function(view) {
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

      // public function to get view_promise
      get viewPromise() {
        return view_promise;
      },

      // generic function to call functions, a bit like R's do.call()
      callView: function(fn, params, run) {

        // sets default for run
        run = run || true;

        // invoke fn
        this.viewPromise.then(function(view) {
          var method = view[fn];
          method.apply(view, params);
          if (run) {
            view.run();
          }
        });
      },

      // Data functions
      insertData: function(name, data_insert, run) {

        // get data into the "right" form
        data_insert = processData(data_insert);

        // invoke view.insert
        this.callView("insert", [name, data_insert], run);
      },

      removeData: function(name, data_remove, run) {

        // set default
        data_remove = data_remove || vega.truthy;

        // get data into the "right" form
        data_remove = processData(data_remove);

        // invoke view.remove
        this.callView("remove", [name, data_remove], run);
      },

      changeData: function(name, data_insert, data_remove, run) {

        // set default
        data_remove = data_remove || vega.truthy;

        // get data into the "right" form
        data_insert = processData(data_insert);
        data_remove = processData(data_remove);

        // build the changeset
        var changeset = vega.changeset()
                            .remove(data_remove)
                            .insert(data_insert);

        // invoke view.change
        this.callView("change", [name, changeset], run);
      },

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

      // callView('insert', [name, data])

      loadData: function(name, data) {
        this.viewPromise.then(function(view) {
          view.insert(name, HTMLWidgets.dataframeToD3(data)).run();
        });
      },

      // Listener functions

      addEventListener: function(event_name, handler) {
        this.viewPromise.then(function(view) {
          view.addEventListener(event_name, handler);
        });
      },

      addSignalListener: function(signal_name, handler) {
        this.viewPromise.then(function(view) {
          view.addSignalListener(signal_name, handler);
        });
      }

    };

  }
});


if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler('callView', function(message) {

    // `message` properties:
    // expected: `id`, `fn`
    // optional: `params`, `run`

    // get, then operate on the Vegawidget object
    Vegawidget.findPromise("#" + message.id).then(function(vwObj) {
      vwObj.callView(message.fn, message.params, message.run);
    });

  });

  Shiny.addCustomMessageHandler('insertData', function(message) {

    // `message` properties:
    // expected: `id`, `data_insert`
    // optional: `run`

    // get, then operate on the Vegawidget object
    Vegawidget.findPromise("#" + message.id).then(function(vwObj) {
      vwObj.insertData(message.name, message.data_insert, message.run);
    });

  });

  Shiny.addCustomMessageHandler('removeData', function(message) {

    // `message` properties:
    // expected: `id`,
    // optional: `data_remove`, `run`

    // get, then operate on the Vegawidget object
    Vegawidget.findPromise("#" + message.id).then(function(vwObj) {
      vwObj.removeData(message.name, message.data_remove, message.run);
    });

  });

  Shiny.addCustomMessageHandler('changeData', function(message) {

    // `message` properties:
    // expected: `id`, `data_insert`
    // optional: `data_remove`, `run`

    // get, then operate on the Vegawidget object
    Vegawidget.findPromise("#" + message.id).then(function(vwObj) {
      vwObj.changeData(message.name, message.data_insert, message.data_remove, message.run);
    });

  });

}

var Vegawidget = {

  // Find, return a promise to a Vegawidget
  //
  // @param selector, string css-selector
  //
  // @return a promise to a Vegawidget
  //
  findPromise: function(selector) {

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

      // get the HTMLWidget object
      var vwObj = HTMLWidgets.find(selector);

      // if it is "defined", resolve it; if not, wait and try again
     	if (vwObj !== undefined) {
    		resolve(vwObj);
    	} else {
    		setTimeout(function() { Vegawidget.findPromise(selector).then(resolve); }, 50);
    	}

    });
  },

  findViewPromise: function(selector) {
    return this.findPromise(selector).then(function(vwObj) {
      return vwObj.viewPromise;
    });
  }

};
