context("test-utils-pipe.R")

test_that("multiplication works", {
  expect_equal(1 %>% sum(1), 1 + 1)
})
