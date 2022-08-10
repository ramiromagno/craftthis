r_headers <- function() {
"#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>"
}

#' @export
craft_src <- function() {
  usethis::use_directory("src")
  usethis::use_git_ignore(c("*.o", "*.so", "*.dll"), "src")
  roxygen_ns_append(glue::glue("@useDynLib {project_name()}, .registration = TRUE")) &&
    roxygen_remind()

  invisible()
}

header_guard_symbol <-
  function(name = NULL,
           prefix = project_name(),
           suffix = 'h') {

    prefix <- snakecase::to_any_case(prefix, case = 'screaming_snake')
    suffix <- snakecase::to_any_case(suffix, case = 'screaming_snake')

    if (is.null(name) || name == "") {
      symbol <- paste(prefix, "MY_HEADER", suffix, sep = "_")
      return(symbol)
    }

    snakecase::to_any_case(
      name,
      case = 'screaming_snake',
      prefix = paste0(prefix, '_'),
      postfix = paste0('_', suffix)
    )

  }

#' @export
craft_h <- function(name = NULL, open = rlang::is_interactive()) {

  full_name <- slug(name, "h")
  check_file_name(name)
  usethis::use_directory("src")

  use_template(template = "module-template.h",
               save_as = fs::path("src", full_name),
               data = list(header_guard_symbol = header_guard_symbol(name = name)),
               open = open)

  invisible(TRUE)
}


#' @export
craft_c <- function(name = NULL, open = rlang::is_interactive(), includes = r_headers()) {

  full_name <- slug(name, "c")
  check_file_name(name)
  usethis::use_directory("src")

  use_template(template = "module-template.c",
               save_as = fs::path("src", full_name),
               data = list(includes = includes),
               open = open)

  invisible(TRUE)
}


