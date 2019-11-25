upper_2iqr <- function(.x) {
    .q <- stats::quantile(.x, c(0.25, 0.75), names = FALSE, na.rm = TRUE)

    .q[2] + 2 * diff(.q)
}


hm_formula_with_param <- function(.k, event, pollut, .data) {
    k_month    <- min(12, length(unique(.data[["month"]])),
        na.rm = TRUE
    )
    k_week_day <- min(7, length(unique(.data[["day_week"]])),
        na.rm = TRUE
    )

    stats::as.formula(glue::glue(
        "{event} ~ ",
        "s({pollut},   bs = 'cr', k = {.k[[1]]}) + ",
        "s(temp_mean,      bs = 'cr', k = {.k[[2]]}) + ",
        "s(press_bar_mean, bs = 'cr', k = {.k[[3]]}) + ",
        "s(day,            bs = 'cr', k = {.k[[4]]}) + ",
        "year + ",
        "s(month,          bs = 'cc', k = {k_month}) + ", # cyclic
        "s(day_week,       bs = 'cc', k =  {k_week_day}) + ", # cyclic
        "ti({pollut}, temp_mean, press_bar_mean, bs = 'cr')"
    ))
}



expand_4_pars_on <- function(.k) {
    expand.grid(.k, .k, .k, .k) %>%
        t() %>%
        `colnames<-`(paste0("V", seq_len(ncol(.)))) %>%
        as.data.frame() %>%
        as.list() %>%
        purrr::map(purrr::set_names, c("k1", "k2", "k3", "k4"))
}



pb_len <- function(.x, width = 76, show_after = 2, clear = FALSE) {
    progress::progress_bar$new(
        format =
            "fitting: :what [:bar] :percent in :elapsed [ETA: :eta]",
        total = .x,
        width = width,
        clear = clear,
        show_after = show_after
    )
}




pollut_avg_event_model <- function(event, polluts, par_grid, data, pb) {
    polluts_models_for_event(event, polluts, par_grid, data, pb) %>%
        MuMIn::model.avg(rank = "BIC")
}


polluts_models_for_event <- function(
    event, polluts, par_grid, data, pb
) {
    polluts %>%
        purrr::map(best_model_for_a_pollut, par_grid, event, data, pb)
}


best_model_for_a_pollut <- function(pollut, par_grid, event, data, pb) {
    train_each_par(par_grid, pollut, event, data, pb) %>%
        .[[which_best(.)]]
}

which_best <- function(models) {
     which.min(purrr::map_dbl(models, stats::BIC))
}

train_each_par <- function(par_grid, pollut, event, data, pb) {
    purrr::imap(par_grid, ~{
        tick(pb, glue::glue("{event}/{pollut}/{.y}"))
        train_hm(hm_formula_with_param(.x, event, pollut, data), data)
    })
}

tick <- function(progress, what) {
    try(progress$tick(tokens = list(what = what)))
}

train_hm <- function(.formula, data) {
    mgcv::gam(.formula, mgcv::nb(), data, select = TRUE)
}

silent_full_join <- function(...) {
    suppressMessages(dplyr::full_join(...))
}

