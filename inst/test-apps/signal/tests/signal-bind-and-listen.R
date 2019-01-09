app <- ShinyDriver$new("../")
app$snapshotInit("signal-bind-and-listen")

# seems to need a little more time to "wake up" on Ian's Mac
app$waitFor("false", timeout = 1000)

app$setInputs(slider = 8)
# Input 'chart_signal_cyl' was set, but doesn't have an input binding.
app$snapshot()
app$setInputs(slider = 4)
# Input 'chart_signal_cyl' was set, but doesn't have an input binding.
app$snapshot()
