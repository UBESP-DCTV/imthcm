library(imthcm)

weather_to_xml(test_weather,
  file = here::here('data/test_weather_history')
)


health_to_xml(test_health,
  file = here::here('data/test_event_history.xml')
)


weather_to_xml(test_weather[c(730, 731), ],
  file = here::here('data/test_weather_new.xml')
)
