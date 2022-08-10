roxygen_ns_append <- function(tag) {
  block_append(
    glue::glue("{tag}"),
    glue::glue("#' {tag}"),
    path = usethis::proj_path(package_doc_path()),
    block_start = "## usethis namespace: start",
    block_end = "## usethis namespace: end",
    block_suffix = "NULL",
    sort = TRUE
  )
}


roxygen_remind <- function() {
  cli::cli_ul("Run {.code devtools::document()} to update {.file NAMESPACE}")
  TRUE
}


