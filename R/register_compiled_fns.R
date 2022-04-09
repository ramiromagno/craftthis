#' @export
register_compiled_fns <- function(path = ".",
                                        quiet = FALSE,
                                        debug = TRUE) {
  pkgbuild::compile_dll(
    path = path,
    force = TRUE,
    register_routines = TRUE,
    quiet = quiet,
    debug = debug
  )
}
