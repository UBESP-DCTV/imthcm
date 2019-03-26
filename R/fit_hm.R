# test_weather <- weather_preproc(ita_weather_history)
#
# health_events_data <- dplyr::left_join(
#       test_weather,
#       ita_events_history
# )



# full_year <-
fit_hm <- function(events, polluts, data,
    par_grid = list(
        default_param = c(k1 = 7, k2 = 7, k3 = 28, k4 = 7)
    ) # expand_4_pars_on(c(7, 28))
) {
    pb <- pb_len(length(par_grid) * length(polluts) * length(events))
    events %>%
        purrr::map(pollut_avg_event_model, polluts, par_grid, data, pb)
}




# data_to_use %>%
#     dplyr::mutate(
#         pma = predict(full_year$mort_cer, type = "response")
#     ) %>%
#     tidyr::gather("key", "value", mort_cer, pma) %>%
#     ggplot2::ggplot(ggplot2::aes(x = pm10, y = value, color = key)) +
#     geom_smooth()

