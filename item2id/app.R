library(shiny)
library(stringr)

ui <- fluidPage(
  titlePanel("item2iD"),
  sidebarLayout(
    sidebarPanel(
      textInput("tag", "Tag:", placeholder = "key=value")
    ),
    mainPanel(
      verbatimTextOutput("code")
    )
  )
)

server <- function(input, output) {
  output$code <- renderText({
    tag <- input$tag |> str_trim()

    if (valid_tag(tag)) {
      tag
    } else {
      "Enter valid tag."
    }
  })
}

shinyApp(ui = ui, server = server)
