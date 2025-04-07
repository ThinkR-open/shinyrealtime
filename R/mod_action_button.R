#' action_button UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_action_button_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "pb-3 d-flex flex-row-reverse",
      div(
        class = "btn-group btn-group-sm",
        role = "group",
        `aria-label` = "Actions",
        actionButton(
          inputId = ns("add"),
          label = "Add a new row",
          class = "btn btn-outline-secondary",
          icon = icon("plus"),
          `data-bs-toggle` = "offcanvas",
          `data-bs-target` = "#add-offcanvas",
        )
      )
    )
  )
}

#' action_button Server Functions
#'
#' @noRd
mod_action_button_server <- function(id, rv) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_action_button_ui("action_button")

## To be copied in the server
# mod_action_button_server("action_button")
