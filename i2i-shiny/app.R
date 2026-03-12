library(shiny)

i2i_repo <- "https://github.com/cuatim/osm-item2id"
id_repo <- "https://github.com/openstreetmap/id-tagging-schema"
examples <- c("amenity=cafe", "playground=playhouse", "highway=cycleway")

ui <- fluidPage(
  titlePanel(span(
    a("i2i", href = i2i_repo),
    "- convert ",
    a("OSM wikibase data items", href = "https://wiki.openstreetmap.org/wiki/Data_items"),
    "to",
    a("iD Tagging Schema", href = id_repo),
    "entries"
  )),
  sidebarLayout(
    sidebarPanel(
      textInput("tag", "Tag:", placeholder = "key=value"),
      p(
        "e.g.,",
        actionLink("example1", examples[1]),
        "·",
        actionLink("example2", examples[2]),
        "·",
        actionLink("example3", examples[3])
      )
    ),
    mainPanel(
      uiOutput("header"),
      verbatimTextOutput("code"),
      uiOutput("footer")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$example1, {
    updateTextInput(inputId = "tag", value = examples[1])
  })

  observeEvent(input$example2, {
    updateTextInput(inputId = "tag", value = examples[2])
  })

  observeEvent(input$example3, {
    updateTextInput(inputId = "tag", value = examples[3])
  })

  preset <- reactive({
    tag <- input$tag |> stringr::str_trim()

    if (valid_tag(tag)) {
      stringr::str_c("Tag:", tag) |>
        get_item() |>
        to_preset()
    } else {
      "Enter valid tag."
    }
  })

  output$code <- renderText({
    preset() |> as_json()
  })

  output$header <- renderUI({
    tag <- attr(preset(), "tag")

    h3(
      "Preset draft for",
      code(a(
        tag,
        href = glue::glue("https://wiki.openstreetmap.org/wiki/Tag:{tag}")
      )),
    )
  })

  output$footer <- renderUI({
    qid <- attr(preset(), "qid")
    key <- attr(preset(), "key")
    value <- attr(preset(), "value")
    filename <- glue::glue("data/presets/{key}/{value}.json")

    tags$ul(
      tags$li(
        "OSM wikibase data item:",
        a(qid, href = glue::glue("https://wiki.openstreetmap.org/wiki/Item:{qid}"))
      ),
      tags$li(
        "iD Tagging Schema path:",
        code(a(filename, href = glue::glue("{id_repo}/tree/main/{filename}")))
      )
    )
  })
}

shinyApp(ui = ui, server = server)
