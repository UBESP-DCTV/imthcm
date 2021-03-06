#' Please install
#'
#' A polite helper for installing and update packages (quite exactly) taken
#' from a function used by Hadley Wickham at
#' `RStudio::conf 2018 - San Diego`.
#'
#' @param pkgs charachter vector of package(s) to install
#' @param install_fun fuction to use for installing package(s)
#' @param ... further options for install_fun
#'
#' @export
#' @return invisible
please_install <- function(pkgs,
                           install_fun = utils::install.packages,
                           ...
){

  if (length(pkgs) == 0) {
    return(invisible())
  }
  if (!interactive()) {
    stop("Please run in interactive session", call. = FALSE)
  }

  title_pkg <- paste0(
    "Ok to install these packges (among the corresponding dependencies)?\n",
    paste("* ", pkgs, collapse = "\n")
  )
  ok_pkg <- utils::menu(c("Yes", "No"), title = title_pkg) == 1

  if (!ok_pkg) {
    return(invisible())
  }

  install_fun(pkgs, ...)

  title_upd <- "Ok to check and update all your packages?"
  ok_upd <- utils::menu(c("Yes", "No"), title = title_upd) == 1

  if (!ok_upd) {
    return(invisible())
  }

  utils::update.packages(ask = FALSE)

  invisible(pkgs)
}

imthcm_packages <- c('magrittr', 'lubridate', 'tibble', 'stats',
  'assertive', 'dplyr', 'purrr', 'glue', 'nlme', 'mgcv', 'rlang', 'tidyr',
  'stringr', 'xml2', 'here', 'ggplot2'
)

#' Check basic installed packages
#'
#' @param pkgs charachter vector of package(s) to check for presence
#'        (default is the vector of packages needed for imthcm package)
#' @param ... further options for install_fun
#'
#' @return invisible character vector with missing package
#' @export
check_pkg <- function(pkgs = imthcm_packages) {
  have   <- rownames(utils::installed.packages())
  needed <- setdiff(pkgs, have)

  invisible(needed)
}
