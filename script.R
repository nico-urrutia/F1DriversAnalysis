#F1 DRIVERS PROJECT
#PARTICIPANTS: Asier Barreira, Aitor Espin and Nicolas Urrutia

#install.packages(c("stringr","tibble","dplyr","ggplot2"))   
library(dplyr)
library(stringr)
library(tibble)
library(ggplot2)


# --- 2. LOADING --- 


file.exists("F1Drivers_Dataset.csv")   # TRUE if the file is in the working folder
drivers <- read.csv(
  file = "F1Drivers_Dataset.csv",
  header = TRUE,
  sep = ",",
  dec = ".",
  quote = "\"",
  na.strings = c("", "NA"),
  fileEncoding = "UTF-8"
)
drivers <- as_tibble(drivers)
print(drivers)

names(drivers)   # Check that the column is called Championship.Years (with a dot)
dim(drivers)     # Should be 868 rows and 22 columns
str(drivers)     # Check the type of each column


#  --- 3. CLEANING ---


# Text problems
# Remove marks like [g] and [w] from driver names
drivers$Driver <- str_remove(drivers$Driver, "\\[.*?\\]")
# Replace the strange space (\u00a0) with a comma when a driver has two nationalities
drivers$Nationality <- str_replace_all(drivers$Nationality, "\u00a0", ", ")
# Change RAF to Russia
drivers$Nationality[drivers$Nationality == "RAF"] <- "Russia"

# Check that no brackets are left and that nationalities look correct
grep("\\[|\\]", drivers$Driver, value = TRUE)   # Should be empty
sort(unique(drivers$Nationality))

# Missing values
colSums(is.na(drivers))   # Only Championship.Years has NA

# Is the NA only for drivers with no titles? (should be TRUE)
all(is.na(drivers$Championship.Years) == (drivers$Championships == 0))
# Decision: we do NOT fill these NA. NA means "never won a championship".

setdiff(seq(min(drivers$Decade), max(drivers$Decade), by = 10), unique(drivers$Decade))

# Check for impossible values (all of these should be 0)
sum(drivers$Race_Starts > drivers$Race_Entries)
sum(drivers$Race_Wins > drivers$Podiums)
sum(drivers$Podiums > drivers$Race_Starts)
sum(drivers$Points < 0)
sum(drivers$Win_Rate < 0 | drivers$Win_Rate > 1)

# Duplicates (both should be 0)
sum(duplicated(drivers))
sum(duplicated(drivers$Driver))

# Outliers 
tuk_wins <- boxplot(drivers$Race_Wins, main = "Race wins")
tuk_wins$out

numcols <- drivers[, sapply(drivers, is.numeric)]

for (col in names(numcols)) {
  outliers <- boxplot.stats(numcols[[col]])$out
  print(paste(col, ":", length(outliers), "outliers"))
}
# Decision: we KEEP the outliers. They are real values: a few drivers
# have many wins, points and championships, while most have very few.

# Normalization of Points
drivers_clean <- mutate(
  drivers,
  Points_minmax = (Points - min(Points)) / (max(Points) - min(Points)),
  Points_std = (Points - mean(Points)) / sd(Points)
)

drivers_clean <- arrange(drivers_clean, desc(Championships), desc(Race_Wins))

print(drivers_clean)

# --- 4. DATA INTEGRATION (Skipped: single file used) ---

# --- 5. TRANSFORMATION ---


# Create a refined dataset of drivers who actually started at least one race
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
    Driver_Tier      =  ifelse(Championships > 0, "World Champion",
                               ifelse(Race_Wins > 0, "Race Winner",
                                      ifelse(Podiums > 0, "Podium Finisher",
                                             ifelse(Points > 0, "Points Scorer", "No Points"))))
  ) %>%
  arrange(desc(Championships), desc(Race_Wins), desc(Points))

print(drivers_transformed)

# Aggregate statistics by Decade 
decade_summary <- drivers_transformed %>%
  group_by(Decade) %>%
  summarise(
    Total_Drivers    = sum(!is.na(Driver)),
    Total_Champions  = sum(Champion, na.rm = TRUE),
    Avg_Race_Starts  = round(mean(Race_Starts, na.rm = TRUE), 1),
    Total_Wins       = sum(Race_Wins, na.rm = TRUE),
    Max_Points       = max(Points, na.rm = TRUE),
    Avg_Points_Start = round(mean(Points_Per_Start, na.rm = TRUE), 2)
  ) %>%
  arrange(Decade)

print(decade_summary)

# Aggregate performance by Nationality
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

# Join the data of each pilot with the resume of the decade 
drivers_transformed <- full_join(drivers_transformed, decade_summary, by = "Decade") %>%
  mutate(
    Points_vs_Decade_Avg = round(Points_Per_Start - Avg_Points_Start, 2)
  )
print(drivers_transformed)


# --- 6. DATA EXPLORATION ---

# Non-visual exploration
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
