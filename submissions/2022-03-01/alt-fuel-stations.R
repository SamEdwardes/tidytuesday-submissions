library(dplyr)
library(ggplot2)
library(janitor)
library(broom)

stations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-01/stations.csv') %>% 
    clean_names()

# Data is from https://team.carto.com/u/andrew/tables/andrew.us_states_hexgrid/public/map
spdf <- geojsonio::geojson_read("submissions/2022-03-01/us_states_hexgrid.geojson",  what = "sp")

hex_data <- spdf@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name)) %>% 
  tidy(region = "google_name")
  as_tibble() 

centers <- cbind.data.frame(data.frame(rgeos::gCentroid(spdf, byid=TRUE), id=spdf@data$iso3166_2)) %>% 
  as_tibble()


ggplot() +
  geom_polygon(data = hex_data, aes( x = long, y = lat, group = group), fill="skyblue", color="white") +
  geom_text(data=centers, aes(x=x, y=y, label=id)) +
  theme_void() +
  coord_map()
