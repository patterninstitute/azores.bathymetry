bathymetry_path <- function() {
  system.file("extdata/NOAA-ETOPO-2022-bedrock-15-arcsec.tiff", package = pkg_name(), mustWork = TRUE)
}
