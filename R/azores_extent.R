#' Azores archipelago region
#'
#' @description
#'
#' [azores_extent()] returns the coordinates of the two vertices of the default
#' bounding box used to defined the Azores region in paikea studies. This region
#' is defined as the bounding box of the Exclusive Economic Zone (EEZ) for the
#' Azores with an extra margin of 50 km in each direction.
#'
#' This extent is for a custom Lambert Azimuthal Equal-Area (LAEA) projection,
#' centered on the Azores. See
#' [laea_azores_proj()][CAOP.RAA.2024::laea_azores_proj] for more details about
#' this projection.
#'
#' @returns A numeric vector of four elements:
#'
#' - `xmin`: most western longitude coordinate, in meters.
#' - `xmax`: most eastern longitude coordinate, in meters.
#' - `ymin`: most southern latitude coordinate, in meters.
#' - `ymax`: most northern latitude coordinate, in meters.
#'
#' @export
azores_extent <- function() {
  # margin of 50 km
  margin <- 50

  # buffer: xmin, xmax, ymin, ymax
  buffer <- c(-margin, -margin, margin, margin) * 1000

  # EEZ + 100 km buffer margin.
  extent_laea <- sf::st_bbox(CAOP.RAA.2024::eez()) + buffer

  extent_laea
}
