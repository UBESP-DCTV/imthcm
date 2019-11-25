#' Weather lag function creator
#'
#' The aim of \code{weather_lag} is to provide functions to compute the
#' the roll mean of pollutant mean daily concentrations, including
#' necessary \code{NA} at the beginning.
#'
#' @param x [num] numerical vector representig a weather daily mean
#'          recording
#' @param k [int] an integer of lenght one indicating how many days befor
#'          the actual (included) has to be considered for the mean
#' @param na.rm [lgl] should \code{NA} be ignored when computed the roll
#'              mean? (default is \code{TRUE})
#'
#'
#' @return a numerical vector of the same lenght of \code{x} with the
#'         roll mean computed (and the first \code{k - 1} entries filed
#'         with \code{NA}).
#'
#' @examples
#' imthcm:::weather_lag(c(1, 2, 3, 4, 5, 6), 2)
#' imthcm:::weather_lag(c(1, 2, 3, 4, 5, 6), 4)
weather_lag <- function(x, k, na.rm = TRUE) {


  # Test input ----------------------------------------------------------

  assertive::assert_is_numeric(x)
  assertive::assert_is_a_number(k)
  assertive::assert_all_are_greater_than_or_equal_to(length(x), k)

  # Run -----------------------------------------------------------------

  purrr::map_dbl(seq_along(x), ~{
    if (.x < k) NA_real_ else mean(x[(.x - k + 1L):.x], na.rm = na.rm)
  })

}




#' @describeIn weather_lag wrapper function to compute
#'             \code{\link{weather_lag}} with \code{k} equal to 2, i.e., the
#'             mean for today and yesterday.
#' @examples
#' imthcm:::weather_lag01(c(1, 2, 3, 4, 5, 6))
weather_lag01 <- function(x, na.rm = TRUE) {
  weather_lag(x, 2L, na.rm = na.rm)
}




#' @describeIn weather_lag wrapper function to compute
#'             \code{\link{weather_lag}} with \code{k} equal to 4, i.e., the
#'             mean for today and three prevous day.
#' @examples
#' imthcm:::weather_lag03(c(1, 2, 3, 4, 5, 6))
weather_lag03 <- function(x, na.rm = TRUE) {
  weather_lag(x, 4L, na.rm = na.rm)
}
