#' Azores bathymetry, depth and elevation
#'
#' [bathymetry()] creates a SpatRaster object for the Azores region with either
#' bathymetry, depth or elevation values (in meters). Use the `var` parameter to
#' choose the variable of interest.
#'
#' @param var Either `"bathymetry"`, `"depth"`, `"elevation"` or
#'   `"depth_slope"`.
#' @param extent The extent of the region to be selected. This should be a
#' numeric vector of four values:
#'
#' - `xmin`: most western longitude coordinate, in decimal degrees.
#' - `xmax`: most eastern longitude coordinate, in decimal degrees.
#' - `ymin`: most southern latitude coordinate, in decimal degrees.
#' - `ymax`: most northern latitude coordinate, in decimal degrees.
#'
#' Defaults to large area centered at the Azores archipelago:
#' `r azores_extent()`.
#'
#' Note that indicating an extent beyond the default limits will not yield
#' more data points.
#'
#' @param resolution A grid cell size, in meters. Can be a single value,
#'   specifying the size for both the x-dimension (longitude) and y-dimension
#'   (latitude), or a vector of two values for an explicit specification.
#'
#' @returns A SpatRaster object cropped to the region selected with `extent`,
#' whose grid cells have a resolution as indicated in the `resolution` parameter
#'
#' @export
bathymetry <- function(var = c("bathymetry", "depth", "elevation", "depth_slope"),
                       extent = azores_extent(),
                       resolution = 1000) {

  var <- match.arg(var)

  bathymetry_path <- bathymetry_path()
  bathymetry <- stars::read_mdim(filename = bathymetry_path)

  bbox <- sf::st_bbox(extent, crs = 4326)
  bathymetry_cropped <- sf::st_crop(x = bathymetry, y = bbox)

  bathymetry_cropped_utm <- stars::st_warp(
    src      = bathymetry_cropped,
    crs      = 32626,
    cellsize = resolution,
    method   = "near"
  )

  bathymetry_rast <- terra::rast(bathymetry_cropped_utm)

  if (identical(var, "bathymetry")) {
    names(bathymetry_rast) <- "bathymetry"
    terra::varnames(bathymetry_rast) <- "Bathymetry"
    terra::longnames(bathymetry_rast) <- "Depth under water and elevation above water"
    return(bathymetry_rast)
  }

  if (identical(var, "depth")) {
    bathymetry_rast[bathymetry_rast > 0] <- NA
    depth_raw_rast <- -bathymetry_rast
    names(depth_raw_rast) <- "depth"
    terra::varnames(depth_raw_rast) <- "Depth"
    terra::longnames(depth_raw_rast) <- "Depth relative to sea level"
    return(depth_raw_rast)
  }

  if (identical(var, "elevation")) {
    bathymetry_rast[bathymetry_rast <= 0] <- NA
    elevation_raw_rast <- bathymetry_rast
    names(elevation_raw_rast) <- "Elevation"
    terra::varnames(elevation_raw_rast) <- "Elevation"
    terra::longnames(elevation_raw_rast) <- "Elevation relative to sea level"
    return(elevation_raw_rast)
  }

  if (identical(var, "depth_slope")) {
    bathymetry_cropped_utm[bathymetry_cropped_utm > 0] <- NA
    depth <- -bathymetry_cropped_utm
    slope <- starsExtra::slope(depth)
    slope_rast <- terra::rast(slope)
    names(slope_rast) <- "Slope"
    terra::varnames(slope_rast) <- "Slope"
    terra::longnames(slope_rast) <- ""
    return(slope_rast)
  }

}
