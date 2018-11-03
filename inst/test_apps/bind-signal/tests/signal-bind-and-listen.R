app <- ShinyDriver$new("../")
app$snapshotInit("signal-bind-and-listen")

app$setInputs(slider = 8)
# Input 'chart_cyl' was set, but doesn't have an input binding.
app$snapshot()
app$setInputs(slider = 4)
# Input 'chart_cyl' was set, but doesn't have an input binding.
app$snapshot()
