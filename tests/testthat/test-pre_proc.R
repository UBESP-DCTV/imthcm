context("test-pre_proc.R")

test_that("class of output is correct", {
  expect_is(weather_preproc(test_weather), 'data.frame')
})
