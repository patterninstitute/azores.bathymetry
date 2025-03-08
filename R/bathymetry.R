#' Azores bathymetry, depth and elevation
#'
#' [bathymetry()] creates a SpatRaster object for the Azores region with either
#' bathymetry, depth or elevation values (in meters). Use the `var` parameter to
#' choose the variable of interest.
#'
#' @param var Either `"bathymetry"`, `"depth"`, `"elevation"` or
#'   `"depth_slope"`.
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
                       resolution = 1000) {

  var <- match.arg(var)
  extent_laea <- azores_extent()
  crs <- CAOP.RAA.2024::laea_azores_proj()

  bathymetry_path <- bathymetry_path()
  bathymetry <- terra::rast(x = bathymetry_path)
  bathymetry2 <- stars::st_as_stars(bathymetry)
  bathymetry3 <- stars::st_warp(bathymetry2, crs = crs)
  bathymetry4 <- sf::st_crop(x = bathymetry3, y = extent_laea)
  bathymetry5 <- stars::st_warp(bathymetry4, crs = crs, cellsize = resolution)
  bathymetry_rast <- terra::rast(bathymetry5)

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
    depth <- -bathymetry5
    slope <- starsExtra::slope(depth)
    slope[bathymetry5 > 0] <- NA
    slope_rast <- terra::rast(slope)
    names(slope_rast) <- "Slope"
    terra::varnames(slope_rast) <- "Slope"
    terra::longnames(slope_rast) <- ""
    return(slope_rast)
  }

}
