#' offcanvas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_offcanvas_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "offcanvas offcanvas-start",
      tabindex = "-1",
      id = "add-offcanvas",
      `aria-labelledby` = "offcanvasLabel",
      div(
        class = "offcanvas-header",
        h5(
          class = "offcanvas-title",
          id = "offcanvasLabel",
          "Add a new row"
        ),
        tags$button(
          type = "button",
          class = "btn-close text-reset",
          `data-bs-dismiss` = "offcanvas",
          `aria-label` = "Close"
        )
      ),
      div(
        class = "offcanvas-body",
        actionButton(
          inputId = ns("save"),
          label = "Save",
          width = "100%",
          class = "btn btn-success btn-sm",
          disabled = TRUE
        )
      )
    )
  )
}

#' offcanvas Server Functions
#'
#' @noRd
mod_offcanvas_server <- function(id, rv) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$save, {
      cat_where(whereami())
      message("Save button clicked")

    })
  })
}

## To be copied in the UI
# mod_offcanvas_ui("offcanvas")

## To be copied in the server
# mod_offcanvas_server("offcanvas")
