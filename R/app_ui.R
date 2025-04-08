#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom bslib page bs_theme
#' @importFrom whereami cat_where whereami
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    page(
      theme = bs_theme(
        primary = "#f1f4fa",
        secondary = "black"
      ),
      mod_navbar_ui("navbar"),
      mod_main_ui("main")
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    tags$script(
      src = "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"
    ),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinyrealtime"
    )
  )
}
