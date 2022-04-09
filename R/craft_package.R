#' Craft a package using C code
#'
#' @description
#' This function creates a bare-bones R package with a minimal C code
#' development support.
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#'   created, provided that the parent path exists.
#' @param fields A named list of fields to add to \code{DESCRIPTION},
#'   potentially overriding default values. See [usethis::use_description()] for
#'   how you can set personalized defaults using package options.
#' @param rstudio If `TRUE`, calls [use_rstudio()] to make the new package or
#'   project into an [RStudio
#'   Project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).
#'    If `FALSE` and a non-package project, a sentinel `.here` file is placed so
#'   that the directory can be recognized as a project by the
#'   [here](https://here.r-lib.org) or
#'   [rprojroot](https://rprojroot.r-lib.org) packages.
#' @param open If `TRUE`, [activates][proj_activate()] the new project:
#'
#'   * If RStudio desktop, the package is opened in a new session.
#'   * If on RStudio server, the current RStudio project is activated.
#'   * Otherwise, the working directory and active project is changed.
#'
#' @return Path to the newly created project or package, invisibly.
#'
#' @md
#' @export
craft_package <-
  function(path,
           fields = list(),
           rstudio = rstudioapi::isAvailable(),
           open = rlang::is_interactive()) {

    # Create R package
    usethis::create_package(path = path,
                            fields = fields,
                            rstudio = rstudio,
                            roxygen = TRUE,
                            check_name = TRUE,
                            open = FALSE)

    # Set the newly created package as the active project
    usethis::local_project(path, force = TRUE)

    # Create package-level documentation. This will hold the roxygen2 tag:
    # @useDynLib <pkgname>, .registration = TRUE"
    usethis::use_package_doc(open = FALSE)

    # Add C infrastructure:
    #   - Creates src/
    #   - Creates src/hello.c
    #   - Add "*.o", "*.so" and "*.dll" to src/.gitignore
    #   - Adds "@useDynLib <pkgname>, .registration = TRUE" to package doc
    rlang::with_options(rlang::with_interactive(usethis::use_c('hello'),
                                                value = FALSE),
                        usethis.quiet = TRUE)

    hello_c_path <-
      system.file('inst/templates/hello.c', package = 'craftthis', mustWork = TRUE)

    hello_r_path <-
      system.file('inst/templates/hello.R', package = 'craftthis', mustWork = TRUE)

    hello_c_new_path <- fs::path(path, 'src', 'hello.c')
    hello_r_new_path <- fs::path(path, 'R', 'hello.R')

    # Here we overwrite hello.c created with usethis::use_c('hello')
    fs::file_copy(path = hello_c_path, new_path = hello_c_new_path, overwrite = TRUE)
    usethis::ui_done("Writing {hello_c_new_path}")
    fs::file_copy(path = hello_r_path, new_path = hello_r_new_path, overwrite = TRUE)
    usethis::ui_done("Writing {hello_r_new_path}")

    # Adds "useDynLib(<pkg_name>, .registration = TRUE)" to NAMESPACE
    devtools::document(pkg = path)

    # Automatic C function registration
    pkgbuild::compile_dll(force = TRUE, register_routines = TRUE)

    if (open) {
      if (usethis::proj_activate(usethis::proj_get())) {
        withr::deferred_clear()
      }
    }

    invisible(usethis::proj_get())
}
