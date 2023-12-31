#' Interface between the Zelig Model gamma.gee and 
#' the Pre-existing Model-fitting Method
#' @param formula a formula
#' @param id a character-string specifying the column of the data-set to use
#'   for clustering
#' @param robust a logical specifying whether to robustly or naively compute
#'   the covariance matrix. This parameter is ignore in the \code{zelig2}
#'   method, and instead used in the \code{robust.hook} function, which
#'   executes after the call to the \code{gee} function
#' @param ... ignored parameters
#' @param R a square-matrix specifying the correlation
#' @param corstr a character-string specifying the correlation structure
#' @param data a data.frame 
#' @return a list specifying the call to the external model
#' @export
zelig2gamma.gee <- function (formula, id, robust, ..., R, corstr = "independence", data) {

  if (corstr == "fixed" && is.null(R))
    stop("R must be defined")

  # if id is a valid column-name in data, then we just need to extract the
  # column and re-order the data.frame and cluster information
  if (is.character(id) && length(id) == 1 && id %in% colnames(data)) {
    id <- data[, id]
    data <- data[order(id), ]
    id <- sort(id)
  }

  list(
       .function = "gee",
       .hook = "robust.hook",
       .post = "clean.up.gamma.gee",

       formula = formula,
       id = id,
       corstr = corstr,
       family  = Gamma,
       data = data,
       ...
       )
}
