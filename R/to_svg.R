to_svg <- function(){
  pjs <- webdriver::run_phantomjs()
  ses <- Session$new(port = pjs$port)
  ses$go("example_widget.html")
  ses$setTimeout(500)
  svg <- ses$executeScriptAsync("var done = arguments[0];
                                getVegaView('htmlwidget-a36d9bcb3cbd26ec2942').toSVG().then(function(svg){done(svg)}).catch(function(err) {console.error(err)});")


}
