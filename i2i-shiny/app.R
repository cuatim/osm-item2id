library(shiny)
library(stringr)

example <- "amenity=cafe"

ui <- fluidPage(
  titlePanel("item2iD"),
  sidebarLayout(
    sidebarPanel(
      textInput("tag", "Tag:", placeholder = "key=value"),
      p("e.g.,", actionLink("example", example))
    ),
    mainPanel(
      verbatimTextOutput("code")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$example, {
    updateTextInput(inputId = "tag", value = example)
  })

  output$code <- renderText({
    tag <- input$tag |> str_trim()

    if (valid_tag(tag)) {
      str_c("Tag:", tag) |>
        get_item() |>
        as_json()
    } else {
      "Enter valid tag."
    }
  })
}

shinyApp(ui = ui, server = server)
