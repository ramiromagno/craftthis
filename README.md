
<!-- README.md is generated from README.Rmd. Please edit that file -->

# craftthis

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

C raft for your R package.

`{craftthis}` is a workflow package: it automates repetitive tasks that
arise during development of R packages that use C code.

## Installation

You can install the development version of `{craftthis}` like so:

``` r
# install.packages("devtools")
devtools::install_github("ramiromagno/craftthis")
```

## Usage

Create an R package named `"mypkg"` that is ready for development with C
code.

``` r
# This will create a new RStudio session whose active project is your package
# mypkg
craftthis::craft_package('mypkg')
```

In the new session load the newly created package and run `hello()`:

``` r
devtools::load_all()

hello()
```

`craft_package()` automatically created a `hello()` R function that
wraps a `hello_()` C function using `.Call()`.
