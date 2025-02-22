#' Azores archipelago region (N26 UTM)
#'
#' [azores_extent_utm()] returns the coordinates of the two vertices of the default
#' bounding box used to defined the Azores region in paikea studies.
#'
#' @returns A numeric vector of four elements:
#'
#' - `xmin`: most western UTM coordinate
#' - `xmax`: most eastern UTM coordinate
#' - `ymin`: most southern UTM coordinate
#' - `ymax`: most northern UTM coordinate
#'
#' @export
azores_extent_utm <- function() {
  extent <- azores_extent_decimal()
  convert_extent_to_utm(extent = extent)
}

#' Azores archipelago region (decimal degrees)
#'
#' [azores_extent_decimal()] returns the coordinates of the two vertices of the default
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
azores_extent_decimal <- function() {
  c(
    xmin = -34,
    xmax = -20,
    ymin = 33,
    ymax = 42
  )
}

#' Convert an extent in N26 UTM to WGS84
#'
#' @description
#' [convert_extent_to_decimal()] takes a named numeric vector:
#'
#' - `xmin`: most western UTM coordinate
#' - `xmax`: most eastern UTM coordinate
#' - `ymin`: most southern UTM coordinate
#' - `ymax`: most northern UTM coordinate
#'
#' And generates a new one whose units have been converted from N26 UTM to WGS84
#' (decimal degrees).
#'
#' @param extent A named numeric vector of four N26 UTM values defining an
#'   extent.
#'
#' @returns A numeric vector.
#'
#' @export
convert_extent_to_decimal <- function(extent = azores_extent_utm()) {

  if (!(all(names(extent) %in% c("xmin", "xmax", "ymin", "ymax")))) {
    stop("Ensure `extent` is a named vector: `xmin`, `xmax`, `ymin`, `ymax`.")
  }

  tbl <-
    tibble::tibble(lon = extent[c("xmin", "xmax")], lat = extent[c("ymin", "ymax")]) |>
    sf::st_as_sf(coords = c("lon", "lat"), crs = 32626) |>
    sf::st_transform(crs = 4326) |>
    sf::st_coordinates() |>
    tibble::as_tibble()

  xmin <- tbl[1, "X", drop = TRUE]
  xmax <- tbl[2, "X", drop = TRUE]
  ymin <- tbl[1, "Y", drop = TRUE]
  ymax <- tbl[2, "Y", drop = TRUE]

  c(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax)
}

#' Convert an extent in WGS84 to N26 UTM
#'
#' @description
#' [convert_extent_to_utm()] takes a named numeric vector:
#'
#' - `xmin`: most western longitude coordinate, in decimal degrees.
#' - `xmax`: most eastern longitude coordinate, in decimal degrees.
#' - `ymin`: most southern latitude coordinate, in decimal degrees.
#' - `ymax`: most northern latitude coordinate, in decimal degrees.
#'
#' And generates a new one whose units have been converted from WGS84 to N26 UTM
#' (meters).
#'
#' @param extent A named numeric vector of four WGS84 values defining an extent.
#'
#' @returns A numeric vector.
#'
#' @export
convert_extent_to_utm <- function(extent = azores_extent_decimal()) {

  if (!(all(names(extent) %in% c("xmin", "xmax", "ymin", "ymax")))) {
    stop("Ensure `extent` is a named vector: `xmin`, `xmax`, `ymin`, `ymax`.")
  }

  tbl <-
    tibble::tibble(lon = extent[c("xmin", "xmax")], lat = extent[c("ymin", "ymax")]) |>
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
    sf::st_transform(crs = 32626) |>
    sf::st_coordinates() |>
    tibble::as_tibble()

  xmin <- tbl[1, "X", drop = TRUE]
  xmax <- tbl[2, "X", drop = TRUE]
  ymin <- tbl[1, "Y", drop = TRUE]
  ymax <- tbl[2, "Y", drop = TRUE]

  c(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax)
}
