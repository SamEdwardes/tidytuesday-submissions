library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)

# Read the data ----
data <- read_csv("https://github.com/ajstarks/dubois-data-portraits/raw/master/challenge/2022/challenge07/data.csv")
females <- read_csv("https://github.com/ajstarks/dubois-data-portraits/raw/master/challenge/2022/challenge07/females.csv")
males <- read_csv("https://github.com/ajstarks/dubois-data-portraits/raw/master/challenge/2022/challenge07/males.csv")

glimpse(data)
glimpse(females)
glimpse(males)

# Tidy the data ---
data <- data %>% 
  pivot_longer(
    cols = c(Widowed, Married, Single), 
    names_to = "Marital Status",
    values_to = "Percent"
  )

# Plot the data ---
data %>% 
  ggplot(aes(x = Percent, y = ))



