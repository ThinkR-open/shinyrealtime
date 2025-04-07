#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  rv <- reactiveValues()

  observeEvent(TRUE, {
    rv$data <- data.frame(
      name = c("Alice", "Bob", "Charlie"),
      age = c(25, 30, 35)
    )
  })

  mod_navbar_server(
    id = "navbar",
    rv = rv
  )

  mod_main_server(
    id = "main",
    rv = rv
  )
}
