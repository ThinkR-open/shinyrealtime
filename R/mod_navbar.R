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
        span(
          class = "navbar-brand",
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

    observeEvent(rv$user_connections, {
      rv$user_connected <- rv$user_connections |>
        filter(is_connected == TRUE) |>
        distinct(user_name) |>
        pull()
    })

    output$avatars <- renderUI({

      lapply(
        rv$user_connected,
        function(user) {

          random_color <- generate_pastel_color(user)

          span(
            class = "avatar",
            title = user,
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
