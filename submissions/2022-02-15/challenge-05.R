library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(glue)
library(lubridate)

# Read the data ----
raw_data <- read_csv("https://github.com/ajstarks/dubois-data-portraits/raw/master/challenge/2022/challenge05/data.csv")

# Tidy the data ----
data <- raw_data %>%
  mutate(
    Free = if_else( Year < 1870, Free / 3, Free / 100),
    Slave = 1 - Free
  ) %>% 
  full_join(
    tibble(
      Date = seq(ymd("1790-01-01"), ymd("1870-12-31"), by = "years"),
      Year = year(Date)
    ),
    by = "Year"
  ) %>% 
  arrange(Date) %>% 
  tidyr::fill(Slave, Free, .direction = "down") %>% 
  pivot_longer(
    cols = c(Slave, Free),
    names_to = "Status",
    values_to = "Percent"
  ) %>% 
  mutate(
    Percent = Percent * 100
  )

data

# Plot the data ----
group_colours <- c(Slave = "black", Free = "red")

data %>% 
  ggplot() +
  geom_area(aes(x = Year, y = Percent, fill = Status), show.legend = FALSE) +
  scale_fill_manual(values = group_colours) +
  geom_text(
    data = raw_data,
    aes(label = glue("{Free}%"), y = 105, x = Year)
  ) +
  scale_x_reverse(breaks = seq(1790, 1870, by = 10)) +
  coord_flip() +
  labs(
    title = "SLAVES AND FREE NEGROS.",
    y = element_blank(),
    x = element_blank()
  ) +
  theme(
    panel.background = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    plot.background = element_rect(fill = "#E0C9A6")
  )

ggplot2::ggsave("submissions/2022-02-15/challenge-05.png", width = 6, height = 10)
