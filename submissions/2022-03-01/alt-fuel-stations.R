library(dplyr)
library(ggplot2)
library(janitor)

stations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-01/stations.csv') %>% 
    clean_names()
