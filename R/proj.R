is_package <- function(base_path = usethis::proj_get()) {
  res <- tryCatch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(e) NULL
  )
  !is.null(res)
}

check_is_package <- function(whos_asking = NULL) {
  if (is_package()) {
    return(invisible())
  }

  message <- "Project {.val {project_name()}} is not an R package."
  if (!is.null(whos_asking)) {
    message <- c(
      "{.code {whos_asking}} is designed to work with packages.",
      message
    )
  }
  cli::cli_abort(message)
}

package_data <- function(base_path = usethis::proj_get()) {
  desc <- desc::description$new(base_path)
  as.list(desc$get(desc$fields()))
}

proj_crit <- function() {
  rprojroot::has_file(".here") |
    rprojroot::is_rstudio_project |
    rprojroot::is_r_package |
    rprojroot::is_git_root |
    rprojroot::is_remake_project |
    rprojroot::is_projectile_project
}

proj_find <- function(path = ".") {
  tryCatch(
    rprojroot::find_root(proj_crit(), path = path),
    error = function(e) NULL
  )
}

possibly_in_proj <- function(path = ".") !is.null(proj_find(path))

is_package <- function(base_path = usethis::proj_get()) {
  res <- tryCatch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(e) NULL
  )
  !is.null(res)
}

project_name <- function(base_path = usethis::proj_get()) {
  ## escape hatch necessary to solve this chicken-egg problem:
  ## create_package() calls use_description(), which calls project_name()
  ## to learn package name from the path, in order to make DESCRIPTION
  ## and DESCRIPTION is how we recognize a package as a usethis project
  if (!possibly_in_proj(base_path)) {
    return(fs::path_file(base_path))
  }

  if (is_package(base_path)) {
    package_data(base_path)$Package
  } else {
    fs::path_file(base_path)
  }
}
