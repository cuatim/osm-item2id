library(shiny)

i2i_repo <- "https://github.com/cuatim/osm-item2id"
id_repo <- "https://github.com/openstreetmap/id-tagging-schema"
examples <- c("amenity=cafe", "playground=playhouse", "highway=cycleway")

ui <- fluidPage(
  titlePanel(
    title = span(
      a("i2i", href = i2i_repo),
      "- convert ",
      a("OSM wikibase data items", href = "https://wiki.openstreetmap.org/wiki/Data_items"),
      "to",
      a("iD Tagging Schema", href = id_repo),
      "entries"
    ),
    windowTitle = "i2i"
  ),
  sidebarLayout(
    sidebarPanel(
      textInput("tag", "Tag:", placeholder = "key=value"),
      p(
        "e.g.,",
        actionLink("example1", examples[1]),
        "•",
        actionLink("example2", examples[2]),
        "•",
        actionLink("example3", examples[3])
      ),
      hr(),
      p(
        a("Learn more", href = glue::glue("{i2i_repo}#creating-a-new-preset")),
        "•",
        a("Source code", href = i2i_repo),
        "(MIT)",
        "•",
        a("Report issue", href = glue::glue("{i2i_repo}/issues"))
      )
    ),
    mainPanel(
      uiOutput("header"),
      verbatimTextOutput("code"),
      uiOutput("footer"),
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

  tag <- reactive({
    tag <- input$tag |> stringr::str_trim() |> stringr::str_remove(".*Tag:")

    req(stringr::str_detect(tag, "^.+=.+$"))

    tag
  })

  item <- reactive({
    validate(
      need(valid_tag(tag()), "Invalid tag.")
    )

    stringr::str_c("Tag:", tag()) |> get_item() |> structure(tag = tag())
  })

  preset <- reactive({
    validate(
      need(identical(purrr::pluck(item(), "type"), "item"), "Data item not found.")
    )

    item() |> to_preset()
  })

  output$code <- renderText({
    preset() |> as_json()
  })

  output$header <- renderUI({
    tag <- tag()

    h3(
      "Preset draft for tag ",
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
