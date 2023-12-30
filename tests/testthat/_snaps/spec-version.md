# vega_schema works

    Code
      vega_schema()
    Output
      [1] "https://vega.github.io/schema/vega-lite/v5.json"

---

    Code
      vega_schema("vega")
    Output
      [1] "https://vega.github.io/schema/vega/v5.json"

---

    Code
      vega_schema("vega_lite", major = FALSE)
    Output
      [1] "https://vega.github.io/schema/vega-lite/v5.16.3.json"

---

    Code
      vega_schema("vega_lite", version = "5.2.0")
    Output
      [1] "https://vega.github.io/schema/vega-lite/v5.2.0.json"

