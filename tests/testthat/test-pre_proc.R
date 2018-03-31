context("test-pre_proc.R")

test_that("class of output is correct", {
  expect_is(weather_preproc(test_weather), 'data.frame')
})


test_that("preprocess works correctly", {
  preproccessed_data <- dplyr::select(test_weather, -o38h) %>%
    weather_preproc

  expect_is(preproccessed_data, 'data.frame')
  expect('o38h' %in% names(preproccessed_data),
         '`o38h` not in names of weather preprocessed data'
  )
  expect_equal(nrow(preproccessed_data), nrow(test_weather))
})
