#F1 DRIVERS PROJECT
#PARTICIPANTS: Asier Barreira, Aitor Espin and Nicolas Urrutia

install.packages(c("stringr","lubridate","tibble","dplyr"))
library(dplyr)
library(stringr)
library(lubridate)
library(tibble)

#2
drivers <- read.csv(
  file = "F1Drivers_Dataset.csv",
  header = TRUE,
  sep = ",",
  dec = ".",
  quote = "\"",
  na.strings = c("", "NA"),
  fileEncoding = "UTF-8"
)
drivers <- tibble(drivers)
print(drivers)

#3
drivers$Driver[drivers$Driver == "Karl-Günther Bechem[g]"] <- "Karl-Günther Bechem"
drivers$Driver[drivers$Driver == "Max Jean[w]"] <- "Max Jean"

drivers$Nationality[drivers$Nationality == "Monaco\u00a0Netherlands"] <- "Monaco, Netherlands"
drivers$Nationality[drivers$Nationality == "Belgium\u00a0France"] <- "Belgium, France"
drivers$Nationality[drivers$Nationality == "RAF"] <- "Russia"

sum(is.na(drivers$Championship.Years))   # 834 pilotos sin mundiales (NA)
sum(!is.na(drivers$Championship.Years))  # 34 campeones con dato válido

tuk_wins <- boxplot(drivers$Race_Wins)
tuk_wins$out

drivers_clean <- mutate(
  drivers,
  Points_minmax = (Points - min(Points)) / (max(Points) - min(Points)),
  Points_std = (Points - mean(Points)) / sd(Points)
)

drivers_clean <- arrange(drivers_clean, desc(Championships), desc(Race_Wins))

print(drivers)
