#' Plot number of costs associated to predicted number of health events
#'
#' A plot that shows the number of average daily costs associated to
#' a particular health event. The bold line represents the
#' point estimate of the mean value of associated to a particular health
#' event. The crossbar represents the 95% confidence interval.
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
#' @return A boxplot showing the costs associated to the predicted number
#'         of a particular health event.
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   default_models <- train_event_models(use_ita = TRUE)
#'
#'   hh_non_summer <- predict_hm(models = default_models,
#'     weather_history = test_weather,
#'     weather_today   = test_weather[731L, ]
#'   )
#'
#'   hh_full_year <- predict_hm(models = default_models,
#'     weather_history = test_weather,
#'     weather_today   = test_weather[c(731L, 730L), ],
#'     full_year = TRUE
#'   )
#'
#'   computed_costs <- compute_cost(hh_non_summer, use_meps = TRUE)
#'   plot_computed_costs(computed_costs,
#'     plot_file = 'costs_plot.png'
#'   )
#' }

plot_computed_costs <- function(computed_costs, plot_file) {

  cost_plot <- computed_costs %>%
    ggplot2::ggplot(
      ggplot2::aes(x = event, y = fit_individual_cost, colour = event)
    ) +
    ggplot2::geom_point() +
    ggplot2::geom_crossbar(
      ggplot2::aes(
        ymin   = lower_individual_cost,
        ymax   = upper_individual_cost),
        fatten = 2
    ) +
    ggplot2::facet_wrap(~date) +
    ggplot2::ggtitle(
      'Costs associated to each health outcome with 95% CI'
    ) +
    ggplot2::xlab('Health Outcomes') +
    ggplot2::ylab('Costs associated to health outcomes') +
    ggplot2::scale_color_discrete(name = 'Health outcomes') +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x  = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank()
    )

  # Provide and possibly write the output -------------------------------

  ggplot2::ggsave(filename = plot_file, plot = cost_plot)
  invisible(cost_plot)
}
