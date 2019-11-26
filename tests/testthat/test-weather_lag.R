context("test-weather_lag.R")

test_that("wrapper return correct results", {
  expect_equal(imthcm:::weather_lag01(c(1, 2, 3, 4)), c(1, 1.5, 2.5, 3.5))
  expect_equal(imthcm:::weather_lag03(c(1, 2, 3, 4)), c(1, 1.5, 2, 2.5))
})

test_that("wrapper correctly manage missing data", {
  expect_equal(imthcm:::weather_lag01(c(1, NA, 3, 4)), c(1, 1, 3, 3.5))
  expect_equal(imthcm:::weather_lag01(c(1, NA, 3, 4), FALSE), c(1, NA, NA, 3.5))
  expect_equal(
    imthcm:::weather_lag03(c(1, NA, 3, 4, 5, 6, 7, 8)),
    c(1, 1, 2, 8/3, 4, 4.5, 5.5, 6.5)
  )
  expect_equal(
    imthcm:::weather_lag03(c(1, NA, 3, 4, 5, 6, 7, 8), FALSE),
    c(1, NA, NA, NA, NA, 4.5, 5.5, 6.5)
  )
})
