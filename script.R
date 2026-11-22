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

colSums(is.na(drivers)) #Vemos que la unica columna con NA es Championship.Years

sum(is.na(drivers$Championship.Years))   # 834 pilotos sin mundiales (NA)
sum(!is.na(drivers$Championship.Years))  # 34 campeones con dato válido

#CHecking that no other columns have suspicious values
summary(drivers)#it looks like there isnt

sum(duplicated(drivers))#no row is duplicated
sum(duplicated(drivers$Driver))#no driver is duplicated

tuk_wins <- boxplot(drivers$Race_Wins)
tuk_wins$out

numcols<-drivers[,sapply(drivers, is.numeric)]

for (col in names(numcols)) {
  outliers <- boxplot.stats(numcols[[col]])$out
  print(paste(col, ":", length(outliers), "outliers"))#we check how many 
  #outliers each numeric column has. a lot of outliers are normal, as most
  #drivers have 0 championships, and a few have many. same with wins and points
}


drivers_clean <- mutate(
  drivers,
  Points_minmax = (Points - min(Points)) / (max(Points) - min(Points)),
  Points_std = (Points - mean(Points)) / sd(Points)
)

drivers_clean <- arrange(drivers_clean, desc(Championships), desc(Race_Wins))

print(drivers_clean)
