#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom reactable reactableOutput renderReactable reactable
mod_main_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "mt-5 mb-3",
      div(
        class = "container",
        div(
          class = "mb-3",
          mod_action_button_ui(
          id = ns("action_button")
          )
        ),
        reactableOutput(
          outputId = ns("table")
        ),
        mod_offcanvas_ui(
            id = ns("offcanvas")
        )
      )
    )
  )
}

#' main Server Functions
#'
#' @noRd
mod_main_server <- function(id, rv) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_action_button_server(
      id = "action_button",
      rv = rv
    )

    mod_offcanvas_server(
      id = "offcanvas",
      rv = rv
    )

    observeEvent(TRUE, {
      cat_where(whereami())

      response <- httr::GET(
        url = paste0(rv$supabase_url, "/rest/v1/iris"),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json"
        ),
        body = body,
        encode = "json"
      )

      rv$iris <- jsonlite::fromJSON(rawToChar(response$content))
    })

    output$table <- renderReactable({
      reactable(
        data = rv$iris,
        defaultSorted = "id",
        defaultSortOrder = "desc"
      )
    })
  })
}

## To be copied in the UI
# mod_main_ui("main")

## To be copied in the server
# mod_main_server("main")
