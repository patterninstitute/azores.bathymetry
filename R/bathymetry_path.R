bathymetry_path <- function() {
  system.file("extdata/bathymetry.nc", package = pkg_name(), mustWork = TRUE)
}
