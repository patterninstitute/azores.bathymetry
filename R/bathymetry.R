#' Azores bathymetry, depth and elevation
#'
#' [bathymetry()] creates a SpatRaster object for the Azores region with either
#' bathymetry, depth or elevation values (in meters). Use the `var` parameter to
#' choose the variable of interest. The area returned in for the Azores,
#' covering the EEZ plus an extra margin of 50 km on each side, see
#' [azores_extent()] for more details.
#'
#' @param var Either `"bathymetry"`, `"depth"`, `"elevation"` or
#'   `"depth_slope"`.
#'
#' @param resolution A grid cell size, in meters. Can be a single value,
#'   specifying the size for both the x-dimension (longitude) and y-dimension
#'   (latitude), or a vector of two values for an explicit specification. By
#'   default the original resolution corresponds to 15 arcsecs.
#'
#' @returns A SpatRaster object.
#'
#' @export
bathymetry <- function(var = c("bathymetry", "depth", "elevation", "depth_slope"),
                       resolution = 500) {

  var <- match.arg(var)

  bathymetry_path <- bathymetry_path()
  bathymetry <- terra::rast(x = bathymetry_path)
  bathymetry2 <- stars::st_as_stars(bathymetry)
  bathymetry3 <- stars::st_warp(bathymetry2, dest = azores_grid(resolution = resolution, type = "stars"))
  bathymetry_rast <- terra::rast(bathymetry3)

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
    depth <- -bathymetry3
    slope <- starsExtra::slope(depth)
    slope[bathymetry3 > 0] <- NA
    slope_rast <- terra::rast(slope)
    names(slope_rast) <- "Slope"
    terra::varnames(slope_rast) <- "Slope"
    terra::longnames(slope_rast) <- ""
    return(slope_rast)
  }

}
