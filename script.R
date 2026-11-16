#F1 DRIVERS PROJECT
#PARTICIPANTS: Asier Barreira, Aitor Espin and Nicolas Urrutia

install.packages(c("stringr","lubridate","tibble"))
library(stringr)
library(lubridate)
library(tibble)

drivers <- read.csv("F1Drivers_Dataset.csv")
