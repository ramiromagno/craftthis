#' Print Hello World
#'
#' This function prints \code{"Hello World!"}.
#'
#' @export
hello <- function() {
  invisible(.Call(hello_))
}
