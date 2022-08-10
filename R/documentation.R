package_doc_path <- function() {
  fs::path("R", paste0(project_name(), "-package"), ext = "R")
}

has_package_doc <- function() {
  fs::file_exists(usethis::proj_path(package_doc_path()))
}
