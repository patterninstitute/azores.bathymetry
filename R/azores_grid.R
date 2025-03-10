azores_grid_stars <- function(resolution = 500) {

  stars <- suppressWarnings(stars::st_as_stars(azores_grid_rast(resolution = resolution)))
  sf::st_crs(stars) <- "+proj=laea +lat_0=38.5 +lon_0=-28 +datum=WGS84 +units=m +no_defs"

  return(stars)
}

azores_grid_rast  <- function(resolution = 500) {
  terra::rast(
    extent = c(
      xmin = -700000,
      xmax = 685000,
      ymin = -590000,
      ymax = 560000
    ),
    resolution = resolution,
    crs = "+proj=laea +lat_0=38.5 +lon_0=-28 +datum=WGS84 +units=m +no_defs"
  )
}

#' Creates an Azores grid
#'
#' [azores_grid()] creates a grid centered around the Azores region.
#'
#' This region is defined as the bounding box of the Exclusive Economic Zone
#' (EEZ) for the Azores with an extra margin of approximately 50 km in each
#' direction.
#'
#' This extent is for a custom Lambert Azimuthal Equal-Area (LAEA) projection,
#' centered on the Azores. See
#' [laea_azores_proj()][CAOP.RAA.2024::laea_azores_proj] for more details about
#' this projection.
#'
#' @param resolution Resolution, defaults to 500 meters.
#' @param type The type of raster object returned: either a SpatRaster
#'   (`"rast"`) or a stars (`"stars"`) object.
#'
#' @returns A SpatRaster object.
#'
#' @export
azores_grid <- function(resolution = 500, type = c("rast", "stars")) {

  type <- match.arg(type)

  if (identical(type, "rast")) {
    return(azores_grid_rast(resolution = resolution))
  } else {
    return(azores_grid_stars(resolution = resolution))
  }

}

#' Azores archipelago region
#'
#' @description
#'
#' [azores_extent()] returns the coordinates of the two vertices of the default
#' bounding box used to defined the Azores region in paikea studies. This region
#' is defined as the bounding box of the Exclusive Economic Zone (EEZ) for the
#' Azores with an extra margin of approximately 50 km in each direction.
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
  sf::st_bbox(azores_grid())
}
