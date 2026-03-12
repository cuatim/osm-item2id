library(shiny)
library(stringr)

examples <- c("amenity=cafe", "playground=playhouse", "highway=cycleway")

ui <- fluidPage(
  titlePanel("item2iD"),
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
      verbatimTextOutput("code")
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

  output$code <- renderText({
    tag <- input$tag |> str_trim()

    if (valid_tag(tag)) {
      str_c("Tag:", tag) |>
        get_item() |>
        to_preset() |>
        as_json()
    } else {
      "Enter valid tag."
    }
  })
}

shinyApp(ui = ui, server = server)
