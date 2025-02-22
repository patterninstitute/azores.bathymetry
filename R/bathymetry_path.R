bathymetry_path <- function() {
  system.file("extdata/gebco_2024_n42.0_s33.0_w-34.0_e-20.0.nc", package = pkg_name(), mustWork = TRUE)
}
