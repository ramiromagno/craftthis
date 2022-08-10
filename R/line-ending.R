proj_line_ending <- function() {
  # First look in .Rproj file
  proj_path <- proj_path(paste0(project_name(), ".Rproj"))
  if (fs::file_exists(proj_path)) {
    config <- xfun::read_utf8(proj_path)

    if (any(grepl("^LineEndingConversion: Posix", config))) {
      return("\n")
    } else if (any(grepl("^LineEndingConversion: Windows", config))) {
      return("\r\n")
    }
  }

  # Then try DESCRIPTION
  desc_path <- proj_path("DESCRIPTION")
  if (fs::file_exists(desc_path)) {
    return(detect_line_ending(desc_path))
  }

  # Then try any .R file
  r_path <- proj_path("R")
  if (fs::dir_exists(r_path)) {
    r_files <- fs::dir_ls(r_path, regexp = "[.][rR]$")
    if (length(r_files) > 0) {
      return(detect_line_ending(r_files[[1]]))
    }
  }

  # Then give up - this is used (for example), when writing the
  # first file into the package
  platform_line_ending()
}

platform_line_ending <- function() {
  if (.Platform$OS.type == "windows") "\r\n" else "\n"
}

detect_line_ending <- function(path) {
  samp <- suppressWarnings(readChar(path, nchars = 500))
  if (isTRUE(grepl("\r\n", samp))) "\r\n" else "\n"
}
