block_append <- function(desc, value, path,
                         block_start = "# <<<",
                         block_end = "# >>>",
                         block_prefix = NULL,
                         block_suffix = NULL,
                         sort = FALSE) {
  if (!is.null(path) && fs::file_exists(path)) {
    lines <- xfun::read_utf8(path)
    if (all(value %in% lines)) {
      return(FALSE)
    }

    block_lines <- block_find(lines, block_start, block_end)
  } else {
    block_lines <- NULL
  }

  if (is.null(block_lines)) {
    cli::cli_ul("
      Copy and paste the following lines into {.file {path}}:")
    cli::cli_code(c(block_prefix, block_start, value, block_end, block_suffix))
    return(FALSE)
  }

  cli::cli_alert_success("Adding {.field {desc}} to {.file {path}}")

  start <- block_lines[[1]]
  end <- block_lines[[2]]
  block <- lines[rlang::seq2(start, end)]

  new_lines <- union(block, value)
  if (sort) {
    new_lines <- sort(new_lines)
  }

  lines <- c(
    lines[rlang::seq2(1, start - 1L)],
    new_lines,
    lines[rlang::seq2(end + 1L, length(lines))]
  )
  xfun::write_utf8(lines, path)

  TRUE
}

block_find <- function(lines, block_start = "# <<<", block_end = "# >>>") {
  # No file
  if (is.null(lines)) {
    return(NULL)
  }

  start <- which(lines == block_start)
  end <- which(lines == block_end)

  # No block
  if (length(start) == 0 && length(end) == 0) {
    return(NULL)
  }

  if (!(length(start) == 1 && length(end) == 1 && start < end)) {
    cli::cli_abort(
      "Invalid block specification.
      Must start with {.code {block_start}} and end with {.code {block_end}}"
    )
  }

  c(start + 1L, end - 1L)
}

