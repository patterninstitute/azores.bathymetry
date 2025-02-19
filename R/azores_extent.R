#' Azores archipelago region
#'
#' [azores_extent()] returns the coordinates of the two vertices of the default
#' bounding box used to defined the Azores region in paikea studies.
#'
#' @returns A numeric vector of four elements:
#'
#' - `xmin`: most western longitude coordinate
#' - `xmax`: most eastern longitude coordinate
#' - `ymin`: most southern latitude coordinate
#' - `ymax`: most northern latitude coordinate
#'
#' @export
azores_extent <- function() {
  c(
    xmin = -34,
    xmax = -21,
    ymin = 34,
    ymax = 42
  )
}
