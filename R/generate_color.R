#' @noRd
generate_pastel_color <- function(name) {
  hue <- sum(utf8ToInt(name)) %% 360
  paste0("hsl(", hue, ", 60%, 60%)")
}
