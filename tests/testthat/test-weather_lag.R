context("test-weather_lag.R")

test_that("wrapper return correct results", {
  expect_equal(weather_lag01(c(1, 2, 3, 4)), c(NA, 1.5, 2.5, 3.5))
  expect_equal(weather_lag03(c(1, 2, 3, 4)), c(NA, NA, NA, 2.5))
})
