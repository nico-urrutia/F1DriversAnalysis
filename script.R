#F1 DRIVERS PROJECT
#PARTICIPANTS: Asier Barreira, Aitor Espin and Nicolas Urrutia

#install.packages(c("stringr","lubridate","tibble","dplyr","ggplot2"))
library(dplyr)
library(stringr)
library(lubridate)
library(tibble)
library(ggplot2)

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

file.exists("F1Drivers_Dataset.csv")   # Comprobar si existe
names(drivers)                         # Confirma que es Championship.Years
dim(drivers)                           # Debe dar 868 filas y 22 columnas

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

# 1. Create a refined dataset of drivers who actually started at least one race

drivers_transformed <- drivers_clean %>%
  filter(Race_Starts > 0) %>%
  select(
    Driver, Nationality, Decade, Years_Active,
    Race_Entries, Race_Starts, Pole_Positions,
    Race_Wins, Podiums, Fastest_Laps, Points,
    Win_Rate, Podium_Rate, Points_Per_Entry,
    Champion, Championships, Points_minmax, Points_std
  ) %>%
  mutate(
    Champion         = (Champion == "True"),
    Start_Efficiency = round(Race_Starts / Race_Entries, 3),
    Points_Per_Start = round(Points / Race_Starts, 2),
    Driver_Tier      = case_when(
      Championships > 0 ~ "World Champion",
      Race_Wins > 0     ~ "Race Winner",
      Podiums > 0       ~ "Podium Finisher",
      Points > 0        ~ "Points Scorer",
      TRUE              ~ "No Points"
    )
  ) %>%
  arrange(desc(Championships), desc(Race_Wins), desc(Points))

print(drivers_transformed)

# 2. Aggregate statistics by Decade 
decade_summary <- drivers_transformed %>%
  group_by(Decade) %>%
  summarise(
    Total_Drivers    = n(),
    Total_Champions  = sum(Champion, na.rm = TRUE),
    Avg_Race_Starts  = round(mean(Race_Starts, na.rm = TRUE), 1),
    Total_Wins       = sum(Race_Wins, na.rm = TRUE),
    Max_Points       = max(Points, na.rm = TRUE),
    Avg_Points_Start = round(mean(Points_Per_Start, na.rm = TRUE), 2)
  ) %>%
  arrange(Decade)

print(decade_summary)

# 3. Aggregate performance by Nationality
nationality_summary <- drivers_transformed %>%
  group_by(Nationality) %>%
  summarise(
    Drivers_Count   = n(),
    Champions_Count = sum(Champion, na.rm = TRUE),
    Total_Wins      = sum(Race_Wins, na.rm = TRUE),
    Total_Podiums   = sum(Podiums, na.rm = TRUE),
    Avg_Win_Rate    = round(mean(Win_Rate, na.rm = TRUE), 3)
  ) %>%
  filter(Total_Wins > 0) %>%
  arrange(desc(Total_Wins))

print(nationality_summary)


#5 DATA EXPLORATION

# Non-visual exploration (Slide 6 & 7)
str(drivers_transformed)
summary(drivers_transformed)
cor(drivers_transformed$Race_Starts, drivers_transformed$Podiums)
cor(drivers_transformed$Race_Wins, drivers_transformed$Points)

# Visual exploration
hist(drivers_transformed$Years_Active,
     main = "Distribution of F1 Drivers' Years Active",
     xlab = "Years Active", col = "lightblue")


ggplot(drivers_transformed, aes(x = Race_Starts, y = Podiums, color = Driver_Tier)) +
  geom_point(alpha = 0.7) +
  labs(
    title = "Race Starts vs. Podiums by Driver Tier",
    x = "Race Starts",
    y = "Podiums"
  )
