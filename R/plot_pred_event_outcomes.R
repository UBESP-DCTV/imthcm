#' Plot number of predicted events in function of type of outcomes
#'
#' A plot that shows the number of average daily predicted events in
#' function of considered outcome is shown. The bold line represents the
#' point estimate of the predicted mean value of the number of health
#' outcome events. The crossbar represents the 95% confidence interval.
#'
#' @param pred_events [data frame] A data frame containing the
#'   following variables:
#'        - `date` : date of simulated day in format 'yyyy-mm-dd';
#'        - `event`: name of the outcomes;
#'        - `lower`: lower bound of 95% CI of average daily predicted number
#'                   of events;
#'        - `fit`  : average daily predicted number of events;
#'        - `upper`: upper bound of 95% CI of average daily predicted number
#'                   of events.
#'
#' @param plot_file [chr] filename of the destination path. Format of image
#'   is automatically decided by the filename extension
#' @return A boxplot showing the number of predicted events for each type of
#'         event
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   default_models <- train_event_models(use_ita = TRUE)
#'   predicted_events <- predict_hm(default_models,
#'     test_weather, test_weather[c(728L, 731L), ]
#'   )
#'   plot_pred_event_outcomes(predicted_events,
#'     plot_file = 'outcome_plot.png'
#'   )
#' }

plot_pred_event_outcomes <- function(pred_events, plot_file) {

  outcome_plot <- pred_events %>%
    ggplot2::ggplot(ggplot2::aes(x = event, y = fit, colour = event)) +
    ggplot2::geom_point() +
    ggplot2::geom_crossbar(
      ggplot2::aes(ymin = lower, ymax = upper),
        fatten = 2
      ) +
    ggplot2::facet_wrap(~date) +
    ggplot2::ggtitle(
      'Number of predicted events for each outcomes with 95% CI'
    ) +
    ggplot2::xlab('Health Outcomes') +
    ggplot2::ylab('Average daily number of events') +
    ggplot2::scale_color_discrete(name = 'Health outcomes') +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x  = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank()
    )

  # Provide and possibly write the output -------------------------------

  ggplot2::ggsave(filename = plot_file, plot = outcome_plot)
}


