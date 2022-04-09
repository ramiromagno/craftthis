#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP hello_() {
  Rprintf("Hello World!\n");
  return(R_NilValue);
}
