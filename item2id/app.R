library(shiny)

ui <- fluidPage(
  titlePanel("item2iD"),
  sidebarLayout(
    sidebarPanel(
      textInput("tag", "Tag:")
    ),
    mainPanel(
      verbatimTextOutput("code")
    )
  )
)

server <- function(input, output) {
  output$code <- renderText({
    input$tag
  })
}

shinyApp(ui = ui, server = server)
