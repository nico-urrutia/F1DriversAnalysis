#F1 DRIVERS PROJECT
#PARTICIPANTS: Asier Barreira, Aitor Espin and Nicolas Urrutia

install.packages(c("stringr","lubridate","tibble"))
library(stringr)
library(lubridate)
library(tibble)

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
