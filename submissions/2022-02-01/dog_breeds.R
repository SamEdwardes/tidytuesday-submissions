library(dplyr)
library(ggplot2)
library(janitor)
library(tidyr)
library(glue)
library(stringr) 

# Read data ----

breed_traits <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_traits.csv') %>% clean_names()
trait_description <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/trait_description.csv') %>% clean_names()
breed_rank_all <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_rank.csv') %>% clean_names()

glimpse(breed_traits)
glimpse(trait_description)
glimpse(breed_rank_all)

# Tidy data ----

breed_rank_all <- breed_rank_all %>% 
  pivot_longer(cols = starts_with("x20"), names_to = "year", values_to = "rank") %>% 
  select(-links, -image) %>% 
  mutate(year = as.numeric(substr(year, 2, 5)))

# Plots ----

## Top 5 ----

top_5_breeds <- breed_rank_all %>% 
  filter(rank <= 5) %>% 
  distinct(breed) %>% 
  pull()

breed_labels <- breed_rank_all %>% 
  filter(
    year == 2013,
    breed %in% top_5_breeds
  )

top_5_data <- breed_rank_all %>% 
  filter(breed %in% top_5_breeds) 


top_5_data %>% 
  ggplot(aes(x = year, y = rank, color = breed)) + 
  geom_line(show.legend = FALSE) +
  geom_point(show.legend = FALSE) +
  geom_label(
    data = breed_labels, 
    aes(x = year, y = rank, label = breed), 
    hjust = 0,
    inherit.aes = FALSE
  ) +
  scale_y_reverse(breaks = c(max(top_5_data$rank):1)) +
  scale_x_continuous(breaks = c(2013:2020)) +
  labs(
    title = "The American Kennel Clubs (AKC) Most Popular Dog Breeds",
    subtitle = str_wrap(glue(
      "The top 5 dog breeds by year. Includes all breeds that have placed in ",
      "the top 5 from 2013 to 2020."
    )),
    x = "Year",
    y = "Rank"
  )

ggplot2::ggsave("submissions/2022-02-01/top-5.png", width = 10, height = 6)

## Biggest movers ----

top_variance_breeds <- breed_rank_all %>% 
  group_by(breed) %>% 
  summarise(variance = var(rank)) %>% 
  arrange(desc(variance)) %>% 
  head(10) %>% 
  pull(breed)

top_variance_breeds_data <- breed_rank_all %>% 
  filter(breed %in% top_variance_breeds)

breed_labels <- breed_rank_all %>% 
  filter(
    year == 2013,
    breed %in% top_variance_breeds
  )

top_variance_breeds_data %>% 
  ggplot(aes(x = year, y = rank, color = breed)) + 
  geom_line(show.legend = FALSE) +
  geom_point(show.legend = FALSE) +
  geom_label(
    data = breed_labels, 
    aes(x = year, y = rank, label = breed), 
    hjust = 0,
    inherit.aes = FALSE
  ) +
  scale_y_reverse() +
  scale_x_continuous(breaks = c(2013:2020)) +
  labs(
    title = "The American Kennel Clubs (AKC) Most Popular Dog Breeds",
    subtitle = str_wrap(glue(
      "The top 5 dog breeds by year. Includes all breeds that have placed in ",
      "the top 5 from 2013 to 2020."
    )),
    x = "Year",
    y = "Rank"
  )


  
