# vw_fetch() works

    Code
      vw_fetch("https://vega.github.io/vega-datasets/data/anscombe.json")
    Output
      [1] "[\n  {\"Series\":\"I\", \"X\":10.0, \"Y\":8.04},\n  {\"Series\":\"I\", \"X\":8.0, \"Y\":6.95},\n  {\"Series\":\"I\", \"X\":13.0, \"Y\":7.58},\n  {\"Series\":\"I\", \"X\":9.0, \"Y\":8.81},\n  {\"Series\":\"I\", \"X\":11.0, \"Y\":8.33},\n  {\"Series\":\"I\", \"X\":14.0, \"Y\":9.96},\n  {\"Series\":\"I\", \"X\":6.0, \"Y\":7.24},\n  {\"Series\":\"I\", \"X\":4.0, \"Y\":4.26},\n  {\"Series\":\"I\", \"X\":12.0, \"Y\":10.84},\n  {\"Series\":\"I\", \"X\":7.0, \"Y\":4.81},\n  {\"Series\":\"I\", \"X\":5.0, \"Y\":5.68},\n  \n  {\"Series\":\"II\", \"X\":10.0, \"Y\":9.14},\n  {\"Series\":\"II\", \"X\":8.0, \"Y\":8.14},\n  {\"Series\":\"II\", \"X\":13.0, \"Y\":8.74},\n  {\"Series\":\"II\", \"X\":9.0, \"Y\":8.77},\n  {\"Series\":\"II\", \"X\":11.0, \"Y\":9.26},\n  {\"Series\":\"II\", \"X\":14.0, \"Y\":8.10},\n  {\"Series\":\"II\", \"X\":6.0, \"Y\":6.13},\n  {\"Series\":\"II\", \"X\":4.0, \"Y\":3.10},\n  {\"Series\":\"II\", \"X\":12.0, \"Y\":9.13},\n  {\"Series\":\"II\", \"X\":7.0, \"Y\":7.26},\n  {\"Series\":\"II\", \"X\":5.0, \"Y\":4.74},\n  \n  {\"Series\":\"III\", \"X\":10.0, \"Y\":7.46},\n  {\"Series\":\"III\", \"X\":8.0, \"Y\":6.77},\n  {\"Series\":\"III\", \"X\":13.0, \"Y\":12.74},\n  {\"Series\":\"III\", \"X\":9.0, \"Y\":7.11},\n  {\"Series\":\"III\", \"X\":11.0, \"Y\":7.81},\n  {\"Series\":\"III\", \"X\":14.0, \"Y\":8.84},\n  {\"Series\":\"III\", \"X\":6.0, \"Y\":6.08},\n  {\"Series\":\"III\", \"X\":4.0, \"Y\":5.39},\n  {\"Series\":\"III\", \"X\":12.0, \"Y\":8.15},\n  {\"Series\":\"III\", \"X\":7.0, \"Y\":6.42},\n  {\"Series\":\"III\", \"X\":5.0, \"Y\":5.73},\n  \n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":6.58},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":5.76},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":7.71},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":8.84},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":8.47},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":7.04},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":5.25},\n  {\"Series\":\"IV\", \"X\":19.0, \"Y\":12.50},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":5.56},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":7.91},\n  {\"Series\":\"IV\", \"X\":8.0, \"Y\":6.89}\n]"

---

    Code
      ct$eval(
        "(async () => {console.log(await vwFetch('https://vega.github.io/vega-datasets/data/anscombe.json'))})()")
    Output
      [
        {"Series":"I", "X":10.0, "Y":8.04},
        {"Series":"I", "X":8.0, "Y":6.95},
        {"Series":"I", "X":13.0, "Y":7.58},
        {"Series":"I", "X":9.0, "Y":8.81},
        {"Series":"I", "X":11.0, "Y":8.33},
        {"Series":"I", "X":14.0, "Y":9.96},
        {"Series":"I", "X":6.0, "Y":7.24},
        {"Series":"I", "X":4.0, "Y":4.26},
        {"Series":"I", "X":12.0, "Y":10.84},
        {"Series":"I", "X":7.0, "Y":4.81},
        {"Series":"I", "X":5.0, "Y":5.68},
        
        {"Series":"II", "X":10.0, "Y":9.14},
        {"Series":"II", "X":8.0, "Y":8.14},
        {"Series":"II", "X":13.0, "Y":8.74},
        {"Series":"II", "X":9.0, "Y":8.77},
        {"Series":"II", "X":11.0, "Y":9.26},
        {"Series":"II", "X":14.0, "Y":8.10},
        {"Series":"II", "X":6.0, "Y":6.13},
        {"Series":"II", "X":4.0, "Y":3.10},
        {"Series":"II", "X":12.0, "Y":9.13},
        {"Series":"II", "X":7.0, "Y":7.26},
        {"Series":"II", "X":5.0, "Y":4.74},
        
        {"Series":"III", "X":10.0, "Y":7.46},
        {"Series":"III", "X":8.0, "Y":6.77},
        {"Series":"III", "X":13.0, "Y":12.74},
        {"Series":"III", "X":9.0, "Y":7.11},
        {"Series":"III", "X":11.0, "Y":7.81},
        {"Series":"III", "X":14.0, "Y":8.84},
        {"Series":"III", "X":6.0, "Y":6.08},
        {"Series":"III", "X":4.0, "Y":5.39},
        {"Series":"III", "X":12.0, "Y":8.15},
        {"Series":"III", "X":7.0, "Y":6.42},
        {"Series":"III", "X":5.0, "Y":5.73},
        
        {"Series":"IV", "X":8.0, "Y":6.58},
        {"Series":"IV", "X":8.0, "Y":5.76},
        {"Series":"IV", "X":8.0, "Y":7.71},
        {"Series":"IV", "X":8.0, "Y":8.84},
        {"Series":"IV", "X":8.0, "Y":8.47},
        {"Series":"IV", "X":8.0, "Y":7.04},
        {"Series":"IV", "X":8.0, "Y":5.25},
        {"Series":"IV", "X":19.0, "Y":12.50},
        {"Series":"IV", "X":8.0, "Y":5.56},
        {"Series":"IV", "X":8.0, "Y":7.91},
        {"Series":"IV", "X":8.0, "Y":6.89}
      ]
      [1] "[object Promise]"

# vw_load() works

    Code
      vw_load(tmpfile)
    Output
      [1] "foobar"

---

    Code
      ct$eval(glue_js("(async () => {console.log(await vwLoad('${tmpfile}'))})()"))
    Output
      foobar
      [1] "[object Promise]"

