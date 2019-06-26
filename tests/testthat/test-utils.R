context("test-utils")

test_that("upper outliers correctly detect", {
    expect_equal(upper_2iqr(0:100), 75 + 2 * 50)
})

test_that("parametric formula works", {

    event <- "sample_event"
    pollutant <- "sample_pollutant"

    expected <- stats::as.formula(glue::glue(
        "{event} ~ ",
        "s({pollutant},   bs = 'cr', k = 1) + ",
        "s(temp_mean,      bs = 'cr', k = 2) + ",
        "s(press_bar_mean, bs = 'cr', k = 3) + ",
        "s(day,            bs = 'cr', k = 4) + ",
        "year + ",
        "s(month,          bs = 'cc', k = 12) + ", # cyclic
        "s(day_week,       bs = 'cc', k =  7) + ", # cyclic
        "ti({pollutant}, temp_mean, press_bar_mean, bs = 'cr')"
    ))

    kk <- c(1, 2, 3, 4)
    sample_data <- data.frame(month = 1:12, day_week = 1:12)

    expect_equal(
        hm_formula_with_param(kk, event, pollutant, sample_data),
        expected
    )
})


test_that("expand kandidates works", {
    res <- expand_4_pars_on(1:3)

    expect_equal(length(res), 81)
    expect_equal(names(res), paste0("V", 1:81))

    expect_equal(length(res[[1]]), 4)
    expect_equal(names(res[[1]]), paste0("k", 1:4))
})


test_that("progress bar creator works", {
   expect_is(pb_len(3), "progress_bar")
})
