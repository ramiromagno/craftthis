#' @export
register_compiled_functions <- function(path = ".",
                                        quiet = FALSE,
                                        debug = TRUE) {
  pkgbuild::compile_dll(
    path = path,
    force = FALSE,
    register_routines = TRUE,
    quiet = quiet,
    debug = debug
  )
}
