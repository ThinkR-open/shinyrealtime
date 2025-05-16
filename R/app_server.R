#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter pull tibble distinct rows_upsert rows_update
#' @noRd
app_server <- function(input, output, session) {

  rv <- reactiveValues(
    supabase_url = Sys.getenv("shinyrealtime_supabase_url"),
    supabase_key = Sys.getenv("shinyrealtime_supabase_key")
  )

  observeEvent(TRUE, once = TRUE, {
    cat_where(whereami())
    message("Starting app server...")
    message(session$user)
    message(session$token)

    session$sendCustomMessage(
      type = "supabaseConfig",
      list(
        url = rv$supabase_url,
        key = rv$supabase_key
      )
    )

    if (getOption("golem.app.prod")) {

      body <- jsonlite::toJSON(
        list(
          user_name = session$user,
          is_connected = TRUE,
          token = session$token
        ),
        auto_unbox = TRUE
      )

      response <- httr::POST(
        url = paste0(rv$supabase_url, "/rest/v1/userConnections?"),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

      rv$current_user <- jsonlite::fromJSON(rawToChar(response$content))
    }

    if (getOption("golem.app.prod")) {

      response <- httr::GET(
        url = paste0(rv$supabase_url, "/rest/v1/userConnections"),
        httr::add_headers(
          "apikey" = rv$supabase_key,
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

      rv$user_connections <- jsonlite::fromJSON(rawToChar(response$content))

    } else {
      rv$user_connections <- data.frame(
        id = c(1, 2, 3),
        user_name = c("user1", "user2", "user3"),
        is_connected = c(TRUE, FALSE, FALSE)
      )
    }
  })

  observeEvent(input$user_connection_update, {
    cat_where(whereami())

    if (getOption("golem.app.prod")) {

      new <- tibble(
        id = input$user_connection_update$new$id,
        token = input$user_connection_update$new$token,
        is_connected = input$user_connection_update$new$is_connected,
      )

      rv$user_connections <- dplyr::rows_update(
        rv$user_connections,
        new,
        by = "id"
      )

    } else {
      rv$user_connections <- data.frame(
        id = c(1, 2, 3),
        user_name = c("user1", "user2", "user3"),
        is_connected = c(TRUE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }
  })

  observeEvent(input$user_connection_insert, {
    cat_where(whereami())

    if (getOption("golem.app.prod")) {

      new <- as.data.frame(
        input$user_connection_insert$new
      )

      rv$user_connections <- dplyr::rows_upsert(
        rv$user_connections,
        new,
        by = "id"
      )

    } else {
      rv$user_connections <- data.frame(
        id = c(1, 2, 3),
        user_name = c("user1", "user2", "user3"),
        is_connected = c(TRUE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }
  })

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
        url = paste0(
          rv$supabase_url,
          "/rest/v1/userConnections?",
          "user_name=eq.", rv$current_user$user_name,
          "&",
          "token=eq.", rv$current_user$token
        ),
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
        user_name = c("user1", "user2", "user3"),
        is_connected = c(FALSE, FALSE, FALSE),
        is_first_visit = c(FALSE, FALSE, FALSE)
      )
    }
  })

  observeEvent(input$iris_insert, {
    cat_where(whereami())

    new <- as.data.frame(
      input$iris_insert$new
    )

    rv$iris <- rows_upsert(
      rv$iris,
      new,
      by = "id"
    )
  })

  session$onSessionEnded(function() {
    cat_where(whereami())
    message("Session ended!!")

    if (getOption("golem.app.prod")) {
      body <- jsonlite::toJSON(
        list(
          is_connected = FALSE
        ),
        auto_unbox = TRUE
      )

      response <- httr::PATCH(
        url = paste0(
          isolate(rv$supabase_url),
          "/rest/v1/userConnections?",
          "user_name=eq.", isolate(rv$current_user$user_name),
          "&",
          "token=eq.", isolate(rv$current_user$token)
        ),
        httr::add_headers(
          "apikey" = isolate(rv$supabase_key),
          "Content-Type" = "application/json",
          "Prefer" = "return=representation"
        ),
        body = body,
        encode = "json"
      )

      cat(rawToChar(response$content), "\n")

    } else {
      rv$users <- data.frame(
        id = c(1, 2, 3),
        user_name = c("user1", "user2", "user3"),
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
