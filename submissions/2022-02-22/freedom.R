library(readr)
library(dplyr)

freedom <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-22/freedom.csv')

test_countries <- c(
  "Canada",
  "United States of America",
  "India",
  "Russia"
)

freedom %>% 
  filter(
    between(year, 2008, 2017),
    country %in% test_countries
  ) %>% 
  arrange(year, country) %>% 
  group_by(year) %>% 
  # mutate(rank = rank())
  filter(country == "United States of America") %>% 
  print(n=100)
  
