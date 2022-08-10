slug <- function(x, ext) {
  x_base <- fs::path_ext_remove(x)
  x_ext <- fs::path_ext(x)
  ext <- if (identical(tolower(x_ext), tolower(ext))) x_ext else ext
  as.character(fs::path_ext_set(x_base, ext))
}

check_file_name <- function(name) {
  if (!rlang::is_string(name)) {
    cli::cli_abort("Name must be a single string")
  }
  if (!valid_file_name(fs::path_ext_remove(name))) {
    cli::cli_abort(c(
      "{.val {name}} is not a valid file name. It should:",
      "* Contain only ASCII letters, numbers, '-', and '_'."
    ))
  }
  name
}

valid_file_name <- function(x) {
  grepl("^[a-zA-Z0-9._-]+$", x)
}
