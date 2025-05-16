# ui <- fluidPage(
#   sliderInput("n", "Number of observations", 2, 1000, 500),
#   plotOutput("plot"),
#   textInput("text", "Enter text:"),
#   textOutput("text"),
# )
#
# server <- function(input, output, session) {
#
#   observe({
#     invalidateLater(500)
#     Sys.sleep(3)
#     print(paste("The value of input$n is", isolate(input$n)))
#   })
#
#   output$text <- renderText({
#     paste("You have entered:", input$text)
#   })
#
#   output$plot <- renderPlot({
#     invalidateLater(2000)
#     hist(rnorm(isolate(input$n)))
#   })
# }
#
# shinyApp(ui, server)
