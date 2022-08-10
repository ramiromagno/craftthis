#' Craft a C module
#'
#' This function creates the initial placeholder for a header file (`.h`) and a
#' C source file (`.c`) that together form a module.
#'
#' @param name Creates and opens `src/<name>.h` and `src/<name>.c`.
#'
#' @return Run for its side effect of writing `src/<name>.h` and `src/<name>.c`.
#'
craft_module <- function(name = NULL) {

  # Create header file for module interface
  craft_h(name = name, open = rlang::is_interactive())

  # Create source code file for module implementation
  includes <- glue::glue('#include "{slug(name, "h")}"')
  craft_c(name = name, open = rlang::is_interactive(), includes = includes)

}
