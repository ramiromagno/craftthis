use_template <- function(template,
                         save_as = template,
                         data = list(),
                         ignore = FALSE,
                         open = FALSE,
                         package = 'craftthis') {

  usethis::use_template(
    template = template,
    save_as = save_as,
    data = data,
    ignore = ignore,
    open = open,
    package = package
  )
}
