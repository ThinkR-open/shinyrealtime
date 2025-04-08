#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter pull tibble
#' @noRd
app_server <- function(input, output, session) {

  rv <- reactiveValues(
    supabase_url = Sys.getenv("shinyrealtime_supabase_url"),
    supabase_key = Sys.getenv("shinyrealtime_supabase_key")
  )

  observeEvent(TRUE, once = TRUE, {
    cat_where(whereami())

    session$sendCustomMessage(
      type = "supabaseConfig",
      list(
        url = rv$supabase_url,
        key = rv$supabase_key
      )
    )

    if (getOption("golem.app.prod")) {

      rv$connected_user <- session$user

      body <- jsonlite::toJSON(
        list(
          name = rv$connected_user,
          is_connected = TRUE,
          is_first_visit = FALSE
        ),
        auto_unbox = TRUE
      )

      response <- httr::PATCH(
        url = paste0(rv$supabase_url, "/rest/v1/users?", "name=eq.", rv$connected_user),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

    } else {
      rv$connected_user <- Sys.getenv("USER")
    }

    if (getOption("golem.app.prod")) {

      response <- httr::GET(
        url = paste0(rv$supabase_url, "/rest/v1/users"),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

      if (httr::status_code(response) == 200) {
        rv$users <- jsonlite::fromJSON(rawToChar(response$content))
      }

    } else {
      rv$users <- data.frame(
        id = c(1, 2, 3),
        name = c("user1", "user2", "user3"),
        is_connected = c(FALSE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }
  })

  observeEvent(input$user_update, {
    cat_where(whereami())

    if (getOption("golem.app.prod")) {

      new <- tibble(
        id = input$user_update$new$id,
        is_connected = input$user_update$new$is_connected,
      )

      rv$users <- dplyr::rows_update(
        rv$users,
        new,
        by = "id"
      )

    } else {
      rv$users <- data.frame(
        id = c(1, 2, 3),
        name = c("user1", "user2", "user3"),
        is_connected = c(TRUE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }
  })


  # session$onSessionEnded(function() {
  #   cat_where(whereami())
  #
  #   if (getOption("golem.app.prod")) {
  #
  #     body <- jsonlite::toJSON(
  #       list(
  #         is_connected = FALSE
  #       ),
  #       auto_unbox = TRUE
  #     )
  #
  #     response <- httr::PATCH(
  #       url = paste0(rv$supabase_url, "/rest/v1/users?", "name=eq.", rv$connected_user),
  #       httr::add_headers(
  #         "apikey" = rv$supabase_key,
  #         "Content-Type" = "application/json",
  #         "Prefer" = "return=representation"
  #       ),
  #       body = body,
  #       encode = "json"
  #     )
  #
  #   } else {
  #     rv$users <- data.frame(
  #       id = c(1, 2, 3),
  #       name = c("user1", "user2", "user3"),
  #       is_connected = c(FALSE, FALSE, FALSE),
  #       is_first_visit = c(FALSE, FALSE, FALSE)
  #     )
  #   }
  # })

  observeEvent(input$user_inactive, {
    cat_where(whereami())

    showModal(modalDialog(
      title = "You are inactive",
      "You've been inactive for a while. Please refresh the page to continue.",
      easyClose = FALSE,
      footer = NULL
    ))

    if (getOption("golem.app.prod")) {

      body <- jsonlite::toJSON(
        list(
          is_connected = FALSE
        ),
        auto_unbox = TRUE
      )

      response <- httr::PATCH(
        url = paste0(rv$supabase_url, "/rest/v1/users?", "name=eq.", rv$connected_user),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

    } else {
      rv$users <- data.frame(
        id = c(1, 2, 3),
        name = c("user1", "user2", "user3"),
        is_connected = c(FALSE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }

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
