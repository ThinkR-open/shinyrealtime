#' offcanvas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom stats runif
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
        numericInput(
          inputId = ns("sep_length"),
          label = "Sepal Length",
          width = '100%',
          value = round(runif(1, min = 1, max = 10), 2),
          min = 0.1,
          max = 10,
          step = 0.1
        ),
        numericInput(
          inputId = ns("sep_width"),
          label = "Sepal Width",
          width = '100%',
          value = round(runif(1, min = 1, max = 10), 2),
          min = 0.1,
          max = 10,
          step = 0.1
        ),
        numericInput(
          inputId = ns("pet_length"),
          label = "Petal Length",
          width = '100%',
          value = round(runif(1, min = 1, max = 10), 2),
          min = 0.1,
          max = 10,
          step = 0.1
        ),
        numericInput(
          inputId = ns("pet_width"),
          label = "Petal Width",
          width = '100%',
          value = round(runif(1, min = 1, max = 10), 2),
          min = 0.1,
          max = 10,
          step = 0.1
        ),
        selectInput(
          inputId = ns("spec"),
          label = "Select a species",
          choices = c(
            "setosa",
            "versicolor",
            "virginica"
          ),
          width = "100%"
        ),
        actionButton(
          inputId = ns("save"),
          label = "Save",
          width = "100%",
          class = "btn btn-success btn-sm"
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

      if (getOption("golem.app.prod")) {
        body <- jsonlite::toJSON(
          list(
            Added_by = rv$current_user$user_name,
            `Sepal.Length` = input$sep_length,
            `Sepal.Width` = input$sep_width,
            `Petal.Length` = input$pet_length,
            `Petal.Width` = input$pet_width,
            Species = input$spec,
            Created_at = Sys.Date()

          ),
          auto_unbox = TRUE
        )
      } else {
        body <- jsonlite::toJSON(
          list(
            Added_by = "test",
            `Sepal.Length` = input$sep_length,
            `Sepal.Width` = input$sep_width,
            `Petal.Length` = input$pet_length,
            `Petal.Width` = input$pet_width,
            Species = input$spec,
            Created_at = Sys.Date()

          ),
          auto_unbox = TRUE
        )
      }

      response <- httr::POST(
        url = paste0(rv$supabase_url, "/rest/v1/iris?"),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

      session$sendCustomMessage(
        "closeOffcanvas",
        list()
      )

      if (response$status_code %in% c(200, 201)) {
        showNotification(
          "Nouvelle ligne ajoutée",
          closeButton = FALSE,
          type = "default",
          duration = 3
        )
      }
    })
  })
}

## To be copied in the UI
# mod_offcanvas_ui("offcanvas")

## To be copied in the server
# mod_offcanvas_server("offcanvas")
