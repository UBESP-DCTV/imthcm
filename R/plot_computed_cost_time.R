#' Plot number of costs associated to predicted number of health events in
#' function of time.
#'
#' A plot that shows the number of average daily costs associated to
#' a particular health event in function of time. The points represent the
#' costs associated to the predicted average daily number of health events.
#' The colours refer to the type of outcome.
#'
#' @param computed_costs [data frame] A data frame containing the
#'   following variables:
#'        - `date`: date of simulated day in format 'yyyy-mm-dd';
#'        - `event`: name of the outcomes;
#'        - `lower_individual_cost`: lower bound of 95% CI of costs
#'           associated to a particular health event;
#'        - `fit_individual_cost`: costs associated to the average daily
#'           number of a particular health event;
#'        - `upper_individual_cost`: upper bound of 95% CI of costs
#'           associated to a particular health event.
#'
#' @param plot_file [chr] filename of the destination path. Format of image
#'   is automatically decided by the filename extension
#' @return A plot with time trends of the costs associated to the average
#'   daily number of predicted ealth outcomes considered.
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   default_models <- train_event_models(use_ita = TRUE)
#'   hh_full_year <- predict_hm(models = default_models,
#'     weather_history = test_weather,
#'     weather_today   = test_weather[c(726L, 729L, 731L), ],
#'     full_year = TRUE
#'   )
#'
#'   computed_costs <- compute_cost(hh_full_year, use_meps = TRUE)
#'   plot_computed_cost_time(computed_costs,
#'     plot_file = 'costs_trend_plot.png'
#'   )
#' }

plot_computed_cost_time <- function(computed_costs, plot_file){

  cost_plot <- computed_costs %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = fit_individual_cost, colour = event)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth() +
    ggplot2::ggtitle('Costs trend') +
    ggplot2::xlab('Date') +
    ggplot2::ylab('Costs of average daily number of health events') +
    ggplot2::scale_color_discrete(name = 'Health outcomes') +
    ggplot2::theme_bw()


  # Provide and possibly write the output -------------------------------

  ggplot2::ggsave(filename = plot_file, plot = cost_plot)
  invisible(cost_plot)
}

