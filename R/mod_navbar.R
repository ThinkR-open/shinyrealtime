#' navbar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_navbar_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$nav(
      class = "navbar navbar-light",
      div(
        class = "container-fluid",
        a(
          class = "navbar-brand",
          href = "/",
          "Shiny Realtime"
        ),
        div(
          class = "navbar-users",
          uiOutput(
            outputId = ns("avatars"),
          )
        )
      )
    )
  )
}

#' navbar Server Functions
#'
#' @noRd
mod_navbar_server <- function(id, rv) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(TRUE, {
      rv$connected_users <- c("Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy")
    })

    output$avatars <- renderUI({

      lapply(
        rv$connected_users,
        function(user) {

          random_color <- generate_pastel_color(user)

          span(
            class = "avatar",
            style = paste0(
              "background-color: ", random_color, ";"
            ),
            substr(user, 1, 1) |>
              toupper()
          )
        }
      )
    })

  })
}

## To be copied in the UI
# mod_navbar_ui("navbar")

## To be copied in the server
# mod_navbar_server("navbar)
