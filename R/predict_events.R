# pred_df <- bind_rows(db, new_data) %>%
#   pre_proc()  %>%
#   mutate(pred = ifelse(month >= 4 & month <= 9,
#                        predict(object = m_ozone,
#                                type = 'response',
#                                se = T)$fit,
#                        predict(object = m,
#                                type = 'response',
#                                se = T)$fit),
#          pred_low_ci = ifelse(month >= 4 & month <= 9,
#                               predict(object = m_ozone,
#                                       type = 'response',
#                                       se = T)$fit - 1.96*
#                                 predict(object = m_ozone,
#                                         type = 'response',
#                                         se = T)$se.fit,
#                               predict(object = m,
#                                       type = 'response',
#                                       se = T)$fit - 1.96*
#                                 predict(object = m,
#                                         type = 'response',
#                                         se = T)$se.fit),
#          pred_up_ci = ifelse(month >= 4 & month <= 9,
#                              predict(object = m_ozone,
#                                      type = 'response',
#                                      se = T)$fit + 1.96*
#                                predict(object = m_ozone,
#                                        type = 'response',
#                                        se = T)$se.fit,
#                              predict(object = m,
#                                      type = 'response',
#                                      se = T)$fit + 1.96*
#                                predict(object = m,
#                                        type = 'response',
#                                        se = T)$se.fit))
