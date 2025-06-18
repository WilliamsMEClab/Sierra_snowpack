"""
This R code is a really big file to help with data cleaning!

You will need to change all the file paths to match how it is
downloaded on your computer.

"""

library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(ggpubr)
library(svglite)
library(DescTools) #used to calculate median 95% confidence intervals
library(extrafont) #imports arial font for figures
library(purrr)
library(flextable)
library(officer)


#import arial font for figures
font_import(pattern = "arial", prompt = FALSE)

#####Data cleaning code below####

#read in the raw model output csv files

era5 <- read.csv("your-file-path-era5.csv")

cesm_hist <- read.csv("your-file-path-cesm_r11i1p1f1_hist_9km.csv")
cesm_ssp370 <- read.csv("your-file-path-cesm_r11i1p1f1_ssp370_9km.csv")

cnrm_hist <- read.csv("your-file-path-cnrm_r1i1p1f2_hist_9km.csv")
cnrm_ssp370 <- read.csv("your-file-path-cnrm_r1i1p1f2_ssp370_9km.csv")

eceveg_hist <- read.csv("your-file-path-ece-veg_r1i1p1f1_hist_9km.csv")
eceveg_ssp370 <- read.csv("your-file-path-ece-veg_r1i1p1f1_ssp370_9km.csv")

fgoals_hist <- read.csv("your-file-path-fgoals_r1i1p1f1_hist_9km.csv")
fgoals_ssp370 <- read.csv("your-file-path-fgoals_r1i1p1f1_ssp370_9km.csv")

access_hist <- read.csv("your-file-path-access-cm2_r5i1p1f1_hist_9km.csv")
access_ssp370 <- read.csv("your-file-path-access-cm2_r5i1p1f1_ssp370_9km.csv")

canesm5_hist <- read.csv("your-file-path-canesm5_r1i1p2f1_hist_9km.csv")
canesm5_ssp370 <- read.csv("your-file-path-canesm5_r1i1p2f1_ssp370_9km.csv")

ece_hist <- read.csv("your-file-path-ec-earth3_r1i1p1f1_hist_9km.csv")
ece_ssp370 <- read.csv("your-file-path-ec-earth3_r1i1p1f1_ssp370_9km.csv")

giss_hist <- read.csv("your-file-path-giss-e2-1-g_r1i1p1f2_hist_9km.csv")
giss_ssp370 <- read.csv("your-file-path-giss-e2-1-g_r1i1p1f2_ssp370_9km.csv")

miroc6_hist <- read.csv("your-file-path-miroc6_r1i1p1f1_hist_9km.csv")
miroc6_ssp370 <- read.csv("your-file-path-miroc6_r1i1p1f1_ssp370_9km.csv")

mpihrr7_hist <- read.csv("your-file-path-mpi-esm1-2-hr_r7i1p1f1_hist_9km.csv")
mpihrr7_ssp370 <- read.csv("your-file-path-mpi-esm1-2-hr_r7i1p1f1_ssp370_9km.csv")

mpihrr3_hist <- read.csv("your-file-path-mpi-esm1-2-hr_r3i1p1f1_hist_9km.csv")
mpihrr3_ssp370 <- read.csv("your-file-path-mpi-esm1-2-hr_r3i1p1f1_ssp370_9km.csv")

mpilr_hist <- read.csv("your-file-path-mpi-esm1-2-lr_r7i1p1f1_hist_9km.csv")
mpilr_ssp370 <- read.csv("your-file-path-mpi-esm1-2-lr_r7i1p1f1_ssp370_9km.csv")

noresm_hist <- read.csv("your-file-path-noresm2-mm_r1i1p1f1_hist_9km.csv")
noresm_ssp370 <- read.csv("your-file-path-noresm2-mm_r1i1p1f1_ssp370_9km.csv")

taiesm_hist <- read.csv("your-file-path-taiesm1_r1i1p1f1_hist_9km.csv")
taiesm_ssp370 <- read.csv("your-file-path-taiesm1_r1i1p1f1_ssp370_9km.csv")

ukesm_hist <- read.csv("your-file-path-ukesm1-0-ll_r2i1p1f2_hist_9km.csv")
ukesm_ssp370 <- read.csv("your-file-path-ukesm1-0-ll_r2i1p1f2_ssp370_9km.csv")



#add columns to each df that indicate the model name before binding the dfs together
era5$model <- "era5"
cesm_hist$model <- "cesm"
cesm_ssp370$model <- "cesm"
cnrm_hist$model <- "cnrm"
cnrm_ssp370$model <- "cnrm"
eceveg_hist$model <- "eceveg"
eceveg_ssp370$model <- "eceveg"
fgoals_hist$model <- "fgoals"
fgoals_ssp370$model <- "fgoals"
access_hist$model <- "access"
access_ssp370$model <- "access"
canesm5_hist$model <- "canesm5"
canesm5_ssp370$model <- "canesm5"
ece_hist$model <- "ece"
ece_ssp370$model <- "ece"
giss_hist$model <- "giss"
giss_ssp370$model <- "giss"
miroc6_hist$model <- "miroc6"
miroc6_ssp370$model <- "miroc6"
mpihrr7_hist$model <- "mpihrr7"
mpihrr7_ssp370$model <- "mpihrr7"
mpihrr3_hist$model <- "mpihrr3"
mpihrr3_ssp370$model <- "mpihrr3"
mpilr_hist$model <- "mpilr"
mpilr_ssp370$model <- "mpilr"
noresm_hist$model <- "noresm"
noresm_ssp370$model <- "noresm"
taiesm_hist$model <- "taiesm"
taiesm_ssp370$model <- "taiesm"
ukesm_hist$model <- "ukesm"
ukesm_ssp370$model <- "ukesm"

#combine data from the eight dfs containing 9km data above
swe_allmodels_9km_df <- bind_rows(
  cesm_hist, cesm_ssp370,
  cnrm_hist, cnrm_ssp370,
  eceveg_hist, eceveg_ssp370,
  fgoals_hist, fgoals_ssp370,
  access_hist, access_ssp370,
  canesm5_hist, canesm5_ssp370,
  ece_hist, ece_ssp370,
  giss_hist, giss_ssp370,
  miroc6_hist, miroc6_ssp370,
  mpihrr3_hist, mpihrr3_ssp370,
  mpihrr7_hist, mpihrr7_ssp370,
  mpilr_hist, mpilr_ssp370,
  noresm_hist, noresm_ssp370,
  taiesm_hist, taiesm_ssp370,
  ukesm_hist, ukesm_ssp370
)

#count the number of observations in combined df from each model as a check
table(swe_allmodels_9km_df$model)



###stop here to make sure everything looks right in the table#####



#drop the 'idx' column from the combined df because it is not necessary
swe_allmodels_9km_df <- subset(swe_allmodels_9km_df, select = -idx)
era5 <- subset(era5, select = -idx)

#calculate average swe values for each model (if applicable) and day across all sampling locations
swe_allmodels_9km_df_regionaverage <- swe_allmodels_9km_df %>%
  group_by(model,day) %>%
  summarize(swe = mean(SWE, na.rm = TRUE)) %>%
  ungroup()

era5_regionaverage <- era5 %>%
  group_by(model, day) %>%
  summarize(swe = mean(SWE, na.rm = TRUE)) %>%
  ungroup()



####the regionaverage versions of the three dfs contain the same data as the original three dfs but averaged across sampling locations#######



#####preparing the water year, month, and day columns from the current day column which contains dates as strings

# Make sure the day column is formatted as a date
swe_allmodels_9km_df_regionaverage$day <- as.Date(swe_allmodels_9km_df_regionaverage$day) 
era5_regionaverage$day <- as.Date(era5_regionaverage$day)

# Create the water year column, adds one to the year if the month is Oct, Nov, or Dec 
swe_allmodels_9km_df_regionaverage <- swe_allmodels_9km_df_regionaverage %>% 
  mutate(water_year = year(day) + if_else(month(day) >= 10, 1, 0))
era5_regionaverage <- era5_regionaverage %>%
  mutate(water_year = year(day) + if_else(month(day) >= 10, 1, 0))

# Create the water month column, subtracts 9 if the month is Oct, Nov, or Dec, adds 3 to the month otherwise 
swe_allmodels_9km_df_regionaverage <- swe_allmodels_9km_df_regionaverage %>% 
  mutate(water_month = if_else(month(day) >= 10, month(day) - 9, month(day) + 3))
era5_regionaverage <- era5_regionaverage %>%
  mutate(water_month = if_else(month(day) >= 10, month(day) - 9, month(day) + 3))

# Create the water day column, which is a number between 1 and 365 starting on Oct 1 of each water year 
swe_allmodels_9km_df_regionaverage <- swe_allmodels_9km_df_regionaverage %>%
  mutate(
    # Calculate the start date of the water year for each row
    water_year_start = as.Date(if_else(month(day) >= 10, 
                                       paste(year(day), "10-01", sep = "-"), 
                                       paste(year(day) - 1, "10-01", sep = "-"))),
    # Calculate the water day by finding the difference from the water year start
    water_day = as.numeric(day - water_year_start) + 1
  )
era5_regionaverage <- era5_regionaverage %>%
  mutate(
    # Calculate the start date of the water year for each row
    water_year_start = as.Date(if_else(month(day) >= 10, 
                                       paste(year(day), "10-01", sep = "-"), 
                                       paste(year(day) - 1, "10-01", sep = "-"))),
    # Calculate the water day by finding the difference from the water year start
    water_day = as.numeric(day - water_year_start) + 1
  )

# remove the temporary water_year_start column 
swe_allmodels_9km_df_regionaverage <- select(swe_allmodels_9km_df_regionaverage, -water_year_start)
era5_regionaverage <- select(era5_regionaverage, -water_year_start)







#########instrumental data processing


#bring in the instrumental data
instrumental_swe_data <- read.csv("C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Data files/Instrumental swe data for period of record/instrumental_swe_data_raw.CSV")

#make sure the swe_in column is in the numeric data type
instrumental_swe_data$swe_in <- as.numeric(as.character(instrumental_swe_data$swe_in))

#keep only rows that are zero or any other number, drop all observations for which swe_in is blank or anything other than a number
instrumental_swe_data <- instrumental_swe_data[!is.na(instrumental_swe_data$swe_in) & is.finite(instrumental_swe_data$swe_in), ]

#add a new column with swe_mm
instrumental_swe_data$swe_mm <- instrumental_swe_data$swe_in*25.4

#drop observations with negative swe values
instrumental_swe_data <- subset(instrumental_swe_data, swe_mm >= 0)

#drop observations from stations that are missing more than half of the 1985 to 2005 data
instrumental_swe_data <- instrumental_swe_data %>%
  filter(!station_code %in% c('TES', 'FRW', 'TNY'))



##date manipulation, creating water_year, water_month, and water_day columns


#make sure the date column is formatted as a date
instrumental_swe_data$date <- as.Date(instrumental_swe_data$date, format="%m/%d/%Y") 

#create the water year column, now adding one to the year if the month is Oct, Nov, or Dec
instrumental_swe_data <- instrumental_swe_data %>% mutate(water_year = year(date) + if_else(month(date) >= 10, 1, 0))

#create the water month column, now subtracting 9 if the month is Oct, Nov, or Dec, and adding 3 to the month otherwise
instrumental_swe_data <- instrumental_swe_data %>% mutate(water_month = if_else(month(date) >= 10, month(date) - 9, month(date) + 3))

#create the water day column, now a number between 1 and 365 starting on Oct 1 of each water year 
instrumental_swe_data <- instrumental_swe_data %>%
  mutate(
    # Calculate the start date of the water year for each row
    water_year_start = as.Date(if_else(month(date) >= 10, 
                                       paste(year(date), "10-01", sep = "-"), 
                                       paste(year(date) - 1, "10-01", sep = "-"))),
    # Calculate the water day by finding the difference from the water year start
    water_day = as.numeric(date - water_year_start) + 1
  )

# remove the temporary water_year_start column 
instrumental_swe_data <- select(instrumental_swe_data, -water_year_start)



#keep only columns of interest in instrumental df
instrumental_swe_data <- instrumental_swe_data %>% select(date, station_code, swe_mm, water_year, water_month, water_day)

#calculate regional average swe for each day
instrumental_swe_data_regionaverage <- instrumental_swe_data %>% 
  group_by(date, water_year, water_month, water_day) %>%
  summarize(swe = mean(swe_mm, na.rm = TRUE)) %>%
  ungroup()

#keep only instrumental data from water years 1986-2005
instrumental_swe_data_regionaverage_1986_2005 <- instrumental_swe_data_regionaverage %>% filter(water_year >= 1986 & water_year <= 2005)


######write out clean datasets prior to analysis#####
#write.csv(instrumental_swe_data_regionaverage_1986_2005, "C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Revision in response to external reviewers/For Zenodo/instrumental_swe_data_regionaverage_1986_2005.csv")
#write.csv(swe_allmodels_9km_df_regionaverage, "C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Revision in response to external reviewers/For Zenodo/swe_allmodels_9km_df_regionaverage.csv")
#write.csv(era5_regionaverage, "C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Revision in response to external reviewers/For Zenodo/era5_regionaverage.csv")



















#####Data analysis and visualization code below#####



##import clean datasets
#instrumental_swe_data_regionaverage_1986_2005 <- read.csv("C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Data files/Clean model and instrumental datasets prior to analysis/instrumental_swe_data_regionaverage_1986_2005.csv")
#swe_allmodels_9km_df_regionaverage <- read.csv("C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Data files/Clean model and instrumental datasets prior to analysis/swe_allmodels_9km_df_regionaverage.csv")
#era5_regionaverage <- read.csv("C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Data files/Clean model and instrumental datasets prior to analysis/era5_regionaverage.csv")

#split the all models df by gcm
swe_ece_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "ece")
swe_miroc6_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "miroc6")
swe_taiesm_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "taiesm")
swe_cesm_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "cesm")
swe_cnrm_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "cnrm")
swe_eceveg_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "eceveg")
swe_fgoals_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "fgoals")
swe_access_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "access")
swe_canesm5_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "canesm5")
swe_giss_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "giss")
swe_mpihrr3_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "mpihrr3")
swe_mpihrr7_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "mpihrr7")
swe_mpilr_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "mpilr")
swe_noresm_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "noresm")
swe_ukesm_9km_df_regionaverage <- subset(swe_allmodels_9km_df_regionaverage, model == "ukesm")






#####split the datasets by time period (historical, mid-century, end-of-century) for analysis 

#define the list of 15 models 
models <- c("ece", "miroc6", "taiesm", "cesm", "cnrm", "eceveg",
            "fgoals", "access", "canesm5", "giss", "mpihrr3", "mpihrr7", 
            "mpilr", "noresm", "ukesm")

# Loop through each model to subset by period, creating a new df for each period for each model
for (model in models) {
  # Retrieve the specific model's data frame
  df <- get(paste0("swe_", model, "_9km_df_regionaverage"))
  
  # Filter and assign 'period' column for historical period (1986-2005)
  assign(paste0("swe_", model, "_9km_df_regionaverage_1986_2005"), df %>%
           filter(water_year >= 1986 & water_year <= 2005) %>%
           mutate(period = "historical"))
  
  # Filter and assign 'period' column for mid-century period (2040-2059)
  assign(paste0("swe_", model, "_9km_df_regionaverage_2040_2059"), df %>%
           filter(water_year >= 2040 & water_year <= 2059) %>%
           mutate(period = "mid-century"))
  
  # Filter and assign 'period' column for end-of-century period (2080-2099)
  assign(paste0("swe_", model, "_9km_df_regionaverage_2080_2099"), df %>%
           filter(water_year >= 2080 & water_year <= 2099) %>%
           mutate(period = "end-of-century"))
}

#subset the reanalysis data for water years 1986-2005
era5_regionaverage_1986_2005 <- era5_regionaverage %>%
  filter(water_year >= 1986 & water_year <= 2005)

##storing each of the dfs for each period and model into a list
all_models_all_periods_list <- list(
  swe_ece_9km_df_regionaverage_1986_2005 = swe_ece_9km_df_regionaverage_1986_2005,
  swe_miroc6_9km_df_regionaverage_1986_2005 = swe_miroc6_9km_df_regionaverage_1986_2005,
  swe_taiesm_9km_df_regionaverage_1986_2005 = swe_taiesm_9km_df_regionaverage_1986_2005,
  swe_cesm_9km_df_regionaverage_1986_2005 = swe_cesm_9km_df_regionaverage_1986_2005,
  swe_cnrm_9km_df_regionaverage_1986_2005 = swe_cnrm_9km_df_regionaverage_1986_2005,
  swe_eceveg_9km_df_regionaverage_1986_2005 = swe_eceveg_9km_df_regionaverage_1986_2005,
  swe_fgoals_9km_df_regionaverage_1986_2005 = swe_fgoals_9km_df_regionaverage_1986_2005,
  swe_access_9km_df_regionaverage_1986_2005 = swe_access_9km_df_regionaverage_1986_2005,
  swe_canesm5_9km_df_regionaverage_1986_2005 = swe_canesm5_9km_df_regionaverage_1986_2005,
  swe_giss_9km_df_regionaverage_1986_2005 = swe_giss_9km_df_regionaverage_1986_2005,
  swe_mpihrr3_9km_df_regionaverage_1986_2005 = swe_mpihrr3_9km_df_regionaverage_1986_2005,
  swe_mpihrr7_9km_df_regionaverage_1986_2005 = swe_mpihrr7_9km_df_regionaverage_1986_2005,
  swe_mpilr_9km_df_regionaverage_1986_2005 = swe_mpilr_9km_df_regionaverage_1986_2005,
  swe_noresm_9km_df_regionaverage_1986_2005 = swe_noresm_9km_df_regionaverage_1986_2005,
  swe_ukesm_9km_df_regionaverage_1986_2005 = swe_ukesm_9km_df_regionaverage_1986_2005,
  swe_ece_9km_df_regionaverage_2040_2059 = swe_ece_9km_df_regionaverage_2040_2059,
  swe_miroc6_9km_df_regionaverage_2040_2059 = swe_miroc6_9km_df_regionaverage_2040_2059,
  swe_taiesm_9km_df_regionaverage_2040_2059 = swe_taiesm_9km_df_regionaverage_2040_2059,
  swe_cesm_9km_df_regionaverage_2040_2059 = swe_cesm_9km_df_regionaverage_2040_2059,
  swe_cnrm_9km_df_regionaverage_2040_2059 = swe_cnrm_9km_df_regionaverage_2040_2059,
  swe_eceveg_9km_df_regionaverage_2040_2059 = swe_eceveg_9km_df_regionaverage_2040_2059,
  swe_fgoals_9km_df_regionaverage_2040_2059 = swe_fgoals_9km_df_regionaverage_2040_2059,
  swe_access_9km_df_regionaverage_2040_2059 = swe_access_9km_df_regionaverage_2040_2059,
  swe_canesm5_9km_df_regionaverage_2040_2059 = swe_canesm5_9km_df_regionaverage_2040_2059,
  swe_giss_9km_df_regionaverage_2040_2059 = swe_giss_9km_df_regionaverage_2040_2059,
  swe_mpihrr3_9km_df_regionaverage_2040_2059 = swe_mpihrr3_9km_df_regionaverage_2040_2059,
  swe_mpihrr7_9km_df_regionaverage_2040_2059 = swe_mpihrr7_9km_df_regionaverage_2040_2059,
  swe_mpilr_9km_df_regionaverage_2040_2059 = swe_mpilr_9km_df_regionaverage_2040_2059,
  swe_noresm_9km_df_regionaverage_2040_2059 = swe_noresm_9km_df_regionaverage_2040_2059,
  swe_ukesm_9km_df_regionaverage_2040_2059 = swe_ukesm_9km_df_regionaverage_2040_2059,
  swe_ece_9km_df_regionaverage_2080_2099 = swe_ece_9km_df_regionaverage_2080_2099,
  swe_miroc6_9km_df_regionaverage_2080_2099 = swe_miroc6_9km_df_regionaverage_2080_2099,
  swe_taiesm_9km_df_regionaverage_2080_2099 = swe_taiesm_9km_df_regionaverage_2080_2099,
  swe_cesm_9km_df_regionaverage_2080_2099 = swe_cesm_9km_df_regionaverage_2080_2099,
  swe_cnrm_9km_df_regionaverage_2080_2099 = swe_cnrm_9km_df_regionaverage_2080_2099,
  swe_eceveg_9km_df_regionaverage_2080_2099 = swe_eceveg_9km_df_regionaverage_2080_2099,
  swe_fgoals_9km_df_regionaverage_2080_2099 = swe_fgoals_9km_df_regionaverage_2080_2099,
  swe_access_9km_df_regionaverage_2080_2099 = swe_access_9km_df_regionaverage_2080_2099,
  swe_canesm5_9km_df_regionaverage_2080_2099 = swe_canesm5_9km_df_regionaverage_2080_2099,
  swe_giss_9km_df_regionaverage_2080_2099 = swe_giss_9km_df_regionaverage_2080_2099,
  swe_mpihrr3_9km_df_regionaverage_2080_2099 = swe_mpihrr3_9km_df_regionaverage_2080_2099,
  swe_mpihrr7_9km_df_regionaverage_2080_2099 = swe_mpihrr7_9km_df_regionaverage_2080_2099,
  swe_mpilr_9km_df_regionaverage_2080_2099 = swe_mpilr_9km_df_regionaverage_2080_2099,
  swe_noresm_9km_df_regionaverage_2080_2099 = swe_noresm_9km_df_regionaverage_2080_2099,
  swe_ukesm_9km_df_regionaverage_2080_2099 = swe_ukesm_9km_df_regionaverage_2080_2099
)



####at this point the instrumental swe data by water year are stored in instrumental_swe_data_regionaverage_1986_2005,
####the era5 swe data by water year are stored in era5_regionaverage_1986_2005,
####and the wrf-gcm swe data by water year are stored a list called all_models_all_periods_list
###that contains dfs for each combination of wrf-gcm and period







####defining functions that find demarcation dates for each water year, 
####durations and rates for each water year from demarcation dates,
####and average demarcation dates and durations/rates across water years

##define a function that finds the spd, sad, and cmd observations for each water year and puts them in a new df labelled "demarc dates"
demarc_dates_fxn <- function(df) {
  
  df <- df[order(df$water_day),] #order the observations by water_day
  max_swe <- max(df$swe, na.rm = TRUE) #find the maximum swe value in each water year
  threshold <- max_swe * 0.1 #define the threshold swe value for sad and cmd with respect to spd
  
  #day of maximum swe in each year (spd)
  spd <- df[which.max(df$swe), ] #grabs the relevant observations from the original df
  spd$label <- "spd" #labels the observations that were grabbed so they can be identified later on
  
  #first day when swe >= 10% of peak swe (sad)
  sad <- df[df$swe >= threshold & df$water_day < spd$water_day, ][1, ]
  sad$label <- "sad"
  
  #first day after the peak <= 10% of peak swe (cmd)
  cmd <- df[df$water_day > spd$water_day & df$swe <= threshold, ][1, ]
  cmd$label <- "cmd"
  
  ##comment the lines immediately below out if using on model data
  rbind(spd, sad, cmd)
  
  ##uncomment the lines below if model data
  result <- rbind(spd, sad, cmd)
  #result$model <- unique(df$model) #retain model
  #result$period <- unique(df$period) #retain period
  return(result)
}

#define the function that finds mean demarcation dates across water years FOR INSTRUMENTAL and REANALYSIS ONLY
avg_demarc_dates_fxn_ins_era5 <- function(df) {
  df_processed <- df %>%
    group_by(label) %>% 
    summarize(mean_water_day = mean(water_day, na.rm = TRUE),
              mean_swe = mean(swe, na.rm = TRUE),
              median_water_day = median(water_day, na.rm = TRUE),
              median_swe = median(swe, na.rm = TRUE),
              water_day_sd = sd(water_day, na.rm = TRUE),
              swe_sd = sd(swe, na.rm = TRUE),
              .groups = 'drop')
}

#define the function that finds the durations and rates FOR WRF-GCM DATA ONLY 
duration_rate_fxn_wrf_gcm <- function(df) {
  results <- df %>%
    group_by(water_year, model, period) %>%
    summarise(
      spd_day = water_day[label == "spd"], 
      sad_day = water_day[label == "sad"], 
      cmd_day = water_day[label == "cmd"], 
      spd_swe = swe[label == "spd"], 
      cmd_swe = swe[label == "cmd"], 
      .groups = 'drop'
    ) %>%
    mutate(
      as_duration = spd_day - sad_day,
      ms_duration = cmd_day - spd_day,
      sar_value = spd_swe / as_duration, 
      smr_value = abs((cmd_swe - spd_swe) / ms_duration)
    ) %>%
    pivot_longer(
      cols = c(as_duration, ms_duration, sar_value, smr_value),
      names_to = "metric",
      values_to = "value"
    ) %>%
    select(water_year, model, period, metric, value)
  
  return(results)
}

##define function that calculates durations and rates FOR INSTRUMENTAL and REANALYSIS ONLY
duration_rate_fxn_ins_era5 <- function(df) {
  
  #get the water day for spd, sad, and cmd
  spd_day <- df$water_day[df$label == "spd"]
  sad_day <- df$water_day[df$label == "sad"]
  cmd_day <- df$water_day[df$label == "cmd"]
  
  #get the swe value for spd and cmd
  spd_swe <- df$swe[df$label == "spd"]
  cmd_swe <- df$swe[df$label == "cmd"]
  
  #calculate as and ms durations
  as_duration <- spd_day - sad_day
  ms_duration <- cmd_day - spd_day
  
  #calculate sar and smr values
  sar_value <- spd_swe / as_duration
  smr_value <- abs((cmd_swe - spd_swe) / ms_duration)
  
  #create output dataframe
  duration_rate_df <- data.frame(
    metric = c("as", "ms", "sar", "smr"),
    value = c(as_duration, ms_duration, sar_value, smr_value)
  )
  
  return(duration_rate_df)
}

#define the function that finds average demarcation dates FOR INSTRUMENTAL AND REANALYSIS ONLY
avg_duration_rate_fxn_ins_era5 <- function(df) {
  df_processed <- df %>%
    group_by(metric) %>%
    summarize(mean = mean(value, na.rm = TRUE), median = median(value, na.rm = TRUE), sd = sd(value, na.rm = TRUE)) %>%
    ungroup()
}





#####processing of instrumental data to find mean dates and metrics across water years 
####and std devs to capture interannual variability

##apply demarcation dates function to instrumental data
instrumental_swe_data_regionaverage_1986_2005_demarcationdates <- instrumental_swe_data_regionaverage_1986_2005 %>%
  group_by(water_year) %>% #group the original df by water year
  do(demarc_dates_fxn(.)) %>% #apply the function that finds observations matching demarcation date criteria to each water year group
  ungroup()

##apply average demarcation dates function to instrumental data, this function also finds std dev values
instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates <- avg_demarc_dates_fxn_ins_era5(instrumental_swe_data_regionaverage_1986_2005_demarcationdates)

#apply duration rate function to instrumental data
instrumental_swe_data_regionaverage_1986_2005_durations_rates <- instrumental_swe_data_regionaverage_1986_2005_demarcationdates %>%
  group_by(water_year) %>% #group the original df by water year
  do(duration_rate_fxn_ins_era5(.)) %>% #apply the function that finds observations matching demarcation date criteria to each water year group
  ungroup()

#apply the average duration rate function to the instrumental data 
instrumental_swe_data_regionaverage_1986_2005_averagedurationrate <- avg_duration_rate_fxn_ins_era5(instrumental_swe_data_regionaverage_1986_2005_durations_rates)


#####processing of era5 data to find mean dates and metrics across water years 
####and std devs to capture interannual variability

#apply demarcation dates function to reanalysis data
era5_regionaverage_1986_2005_demarcationdates <- era5_regionaverage_1986_2005 %>%
  group_by(water_year) %>%
  do(demarc_dates_fxn(.)) %>% 
  ungroup()

#apply the average demarcation dates function to era5 data
era5_regionaverage_1986_2005_averagedemarcationdates <- avg_demarc_dates_fxn_ins_era5(era5_regionaverage_1986_2005_demarcationdates)

#apply duration rate function to era5 data
era5_regionaverage_1986_2005_durations_rates <- era5_regionaverage_1986_2005_demarcationdates %>%
  group_by(water_year) %>%
  do(duration_rate_fxn_ins_era5(.)) %>%
  ungroup()

#apply the average duration rate function to era5 data
era5_regionaverage_1986_2005_averagedurationrate <- avg_duration_rate_fxn_ins_era5(era5_regionaverage_1986_2005_durations_rates)



#####creating one df with demarcation date values and one df with duration/rate values for each wrf-gcm and water year#####

##apply the demarcation date function to all wrf-gcm dfs
all_models_all_periods_demarc_dates_list <- lapply(all_models_all_periods_list, function(df) {
  grouped_df <- group_by(df, water_year)
  demarcation_dates_df <- do(grouped_df, demarc_dates_fxn(.))
  ungroup(demarcation_dates_df)  
})

#getting durations and rates by applying the duration rate function to all demarcation date dfs 
all_models_all_periods_duration_rate_list <- lapply(all_models_all_periods_demarc_dates_list, duration_rate_fxn_wrf_gcm)

####the next step is to find wrf-gcm ensemble values for each date, metric, and water year####

#to do this, first I need to bind the individual dfs in each list together
all_models_all_periods_demarc_date_df <- bind_rows(all_models_all_periods_demarc_dates_list)
all_models_all_periods_duration_rate_df <- bind_rows(all_models_all_periods_duration_rate_list)

#now generate the dfs with wrf-gcm ensemble values
wrf_gcm_ensemble_all_periods_demarc_date_df <- all_models_all_periods_demarc_date_df %>%
  group_by(period, label, water_year, water_day) %>%
  summarize(swe = mean(swe, na.rm = TRUE)) %>%
  ungroup()
wrf_gcm_ensemble_all_periods_duration_rate_df <- all_models_all_periods_duration_rate_df %>%
  group_by(metric, period, water_year) %>%
  summarize(value = mean(value, na.rm = TRUE)) %>%
  ungroup()

####the next step is to find period means, medians, standard deviations for each date and metric####
wrf_gcm_ensemble_period_average_demarc_date_df <- wrf_gcm_ensemble_all_periods_demarc_date_df %>%
  group_by(period, label) %>%
  summarize(water_day_mean = mean(water_day, na.rm = TRUE),
            water_day_median = median(water_day, na.rm = TRUE),
            water_day_sd = sd(water_day, na.rm = TRUE),
            swe_mean = mean(swe, na.rm = TRUE),
            swe_median = median(swe, na.rm = TRUE),
            swe_sd = sd(swe, na.rm = TRUE)) %>%
  ungroup()
wrf_gcm_ensemble_period_average_duration_rate_df <- wrf_gcm_ensemble_all_periods_duration_rate_df %>%
  group_by(period, metric) %>%
  summarize(mean = mean(value, na.rm = TRUE),
            median = median(value, na.rm = TRUE),
            sd = sd(value, na.rm = TRUE)) %>%
  ungroup()




#####combine the demarcation date dfs#####

#instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates
#era5_regionaverage_1986_2005_averagedemarcationdates
#wrf_gcm_ensemble_period_average_demarc_date_df

# Add a source column to each data frame
instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates <- 
  instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates %>%
  mutate(source = "instrumental")
era5_regionaverage_1986_2005_averagedemarcationdates <- 
  era5_regionaverage_1986_2005_averagedemarcationdates %>%
  mutate(source = "era5")
wrf_gcm_ensemble_period_average_demarc_date_df <- 
  wrf_gcm_ensemble_period_average_demarc_date_df %>%
  mutate(source = "wrf_gcm")

# Rename columns to have consistent names
instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates <- 
  instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates %>%
  rename(water_day_mean = mean_water_day, water_day_median = median_water_day, swe_mean = mean_swe, swe_median = median_swe)
era5_regionaverage_1986_2005_averagedemarcationdates <- 
  era5_regionaverage_1986_2005_averagedemarcationdates %>%
  rename(water_day_mean = mean_water_day, water_day_median = median_water_day, swe_mean = mean_swe, swe_median = median_swe)

# Combine all data frames
demarc_dates_df <- bind_rows(
  instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates,
  era5_regionaverage_1986_2005_averagedemarcationdates,
  wrf_gcm_ensemble_period_average_demarc_date_df
)

#######combine the duration rate dfs##########

#instrumental_swe_data_regionaverage_1986_2005_averagedurationrate
#era5_regionaverage_1986_2005_averagedurationrate
#wrf_gcm_ensemble_period_average_duration_rate_df

# Add a source column to each data frame
instrumental_swe_data_regionaverage_1986_2005_averagedurationrate <- 
  instrumental_swe_data_regionaverage_1986_2005_averagedurationrate %>%
  mutate(source = "instrumental")
era5_regionaverage_1986_2005_averagedurationrate <- 
  era5_regionaverage_1986_2005_averagedurationrate %>%
  mutate(source = "era5")
wrf_gcm_ensemble_period_average_duration_rate_df <- 
  wrf_gcm_ensemble_period_average_duration_rate_df %>%
  mutate(source = "wrf_gcm")

#combine all dfs
durations_rates_df <- bind_rows(
  instrumental_swe_data_regionaverage_1986_2005_averagedurationrate,
  era5_regionaverage_1986_2005_averagedurationrate,
  wrf_gcm_ensemble_period_average_duration_rate_df
)

#####create one df for each set of things with the same units (e.g. mm, water year day, days, and mm/day)#####

##one df for spd swe values (mm units)
spd_swe_df <- demarc_dates_df %>%
  filter(label == "spd") %>% #we only want the spd obs
  select(
    var = label, #rename label to var
    mean = swe_mean, #rename swe_mean to mean
    median = swe_median, #rename swe_median to median
    sd = swe_sd, #rename swe_sd to sd
    source,
    period
  ) %>%
  mutate(var = "spd_swe") #set the value of var to "spd_swe"

##one df for sad, spd, and cmd values (water year day units)
timing_df <- demarc_dates_df %>%
  filter(label %in% c("sad", "spd", "cmd")) %>%
  select(
    var = label,
    mean = water_day_mean,
    median = water_day_median,
    sd = water_day_sd,
    source,
    period
  )

##one for the durations (units are days)
durations_df <- durations_rates_df %>%
  filter(metric %in% c("as", "as_duration", "ms", "ms_duration")) %>%
  select(
    var = metric,
    mean = mean,
    median = median,
    sd = sd,
    source,
    period
  )

#rename all as/ms values in the var column for consistency
durations_df <- durations_df %>%
  mutate(
    var = as.character(var),
    var = gsub("_duration", "", var)
  )

##one for the rates (units are mm/day)
rates_df <- durations_rates_df %>%
  filter(metric %in% c("sar", "sar_value", "smr", "smr_value")) %>%
  select(
    var = metric,
    mean = mean,
    median = median,
    sd = sd,
    source,
    period
  )


###adding a value in the period column for instrumental and era5 observations
# Update 'period' column for spd_swe_df
spd_swe_df <- spd_swe_df %>%
  mutate(period = ifelse(source %in% c("instrumental", "era5"), "historical", period))

# Update 'period' column for timing_df
timing_df <- timing_df %>%
  mutate(period = ifelse(source %in% c("instrumental", "era5"), "historical", period))

# Update 'period' column for durations_df
durations_df <- durations_df %>%
  mutate(period = ifelse(source %in% c("instrumental", "era5"), "historical", period))

# Update 'period' column for rates_df
rates_df <- rates_df %>%
  mutate(period = ifelse(source %in% c("instrumental", "era5"), "historical", period))


#rename all sar/smr values in the var column for consistency
rates_df <- rates_df %>%
  mutate(
    var = as.character(var),
    var = gsub("_value", "", var)
  )

#####calculate interannual mean confidence interval upper and lower bounds (use 'uppper' and lower' terminology)

#the dfs that have wrf-gcm ensemble, instrumental, and era5 dates and metrics for each water year are the following:
#wrf_gcm_ensemble_all_periods_demarc_date_df, wrf_gcm_ensemble_all_periods_duration_rate_df,
#era5_regionaverage_1986_2005_durations_rates, era5_regionaverage_1986_2005_demarcationdates,
#instrumental_swe_data_regionaverage_1986_2005_demarcationdates, 
#instrumental_swe_data_regionaverage_1986_2005_durations_rates

#split out wrf-gcm demarc date df into component dfs
wrfgcmensemble_historical_spd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                             period == "historical" & label == "spd")
wrfgcmensemble_midcentury_spd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                              period == "mid-century" & label == "spd")
wrfgcmensemble_latecentury_spd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                               period == "end-of-century" & label == "spd")
wrfgcmensemble_historical_sad <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                             period == "historical" & label == "sad")
wrfgcmensemble_midcentury_sad <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                              period == "mid-century" & label == "sad")
wrfgcmensemble_latecentury_sad <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                               period == "end-of-century" & label == "sad")
wrfgcmensemble_historical_cmd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                             period == "historical" & label == "cmd")
wrfgcmensemble_midcentury_cmd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                              period == "mid-century" & label == "cmd")
wrfgcmensemble_latecentury_cmd <- subset(wrf_gcm_ensemble_all_periods_demarc_date_df,
                                               period == "end-of-century" & label == "cmd")


#split out wrf-gcm duration rate df into component dfs
wrfgcmensemble_historical_sar <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                              period == "historical" & metric == "sar_value")
wrfgcmensemble_midcentury_sar <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                              period == "mid-century" & metric == "sar_value")
wrfgcmensemble_latecentury_sar <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                               period == "end-of-century" & metric == "sar_value")
wrfgcmensemble_historical_smr <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                             period == "historical" & metric == "smr_value")
wrfgcmensemble_midcentury_smr <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                              period == "mid-century" & metric == "smr_value")
wrfgcmensemble_latecentury_smr <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                               period == "end-of-century" & metric == "smr_value")
wrfgcmensemble_historical_as <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                             period == "historical" & metric == "as_duration")
wrfgcmensemble_midcentury_as <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                              period == "mid-century" & metric == "as_duration")
wrfgcmensemble_latecentury_as <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                               period == "end-of-century" & metric == "as_duration")
wrfgcmensemble_historical_ms <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                             period == "historical" & metric == "ms_duration")
wrfgcmensemble_midcentury_ms <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                              period == "mid-century" & metric == "ms_duration")
wrfgcmensemble_latecentury_ms <- subset(wrf_gcm_ensemble_all_periods_duration_rate_df,
                                               period == "end-of-century" & metric == "ms_duration")
  
  

#split out era5 demarc date df into component dfs
era5_spd <- subset(era5_regionaverage_1986_2005_demarcationdates, label == "spd")
era5_sad <- subset(era5_regionaverage_1986_2005_demarcationdates, label == "sad")
era5_cmd <- subset(era5_regionaverage_1986_2005_demarcationdates, label == "cmd")
  
#split out era5 duration rate df into component dfs
era5_sar <- subset(era5_regionaverage_1986_2005_durations_rates, metric == "sar")
era5_smr <- subset(era5_regionaverage_1986_2005_durations_rates, metric == "smr")
era5_as <- subset(era5_regionaverage_1986_2005_durations_rates, metric == "as")
era5_ms <- subset(era5_regionaverage_1986_2005_durations_rates, metric == "ms")
  
#split out era5 demarc date df into component dfs
ins_spd <- subset(instrumental_swe_data_regionaverage_1986_2005_demarcationdates, label == "spd")
ins_sad <- subset(instrumental_swe_data_regionaverage_1986_2005_demarcationdates, label == "sad")
ins_cmd <- subset(instrumental_swe_data_regionaverage_1986_2005_demarcationdates, label == "cmd")

#split out era5 duration rate df into component dfs
ins_sar <- subset(instrumental_swe_data_regionaverage_1986_2005_durations_rates, metric == "sar")
ins_smr <- subset(instrumental_swe_data_regionaverage_1986_2005_durations_rates, metric == "smr")
ins_as <- subset(instrumental_swe_data_regionaverage_1986_2005_durations_rates, metric == "as")
ins_ms <- subset(instrumental_swe_data_regionaverage_1986_2005_durations_rates, metric == "ms")

#create a df to which median 95% CI results will be appended

median_ci_results <- data.frame(
  Median = numeric(0),
  Lower_Bound = numeric(0),
  Upper_Bound = numeric(0),
  Source = character(0),
  Var = character(0)
)

#define function that calculates median 95% CI upper and lower bound values for swe distributions

swe_ci_bounds <- function(df, df_name) {
  #calculate CI for the median of the column of interest
  ci_result <- MedianCI(df$swe, conf.level = 0.95, sides = "two", method = "exact")
  
  #create new df with results
  new_row <- data.frame(
    Median = ci_result[1],
    Lower_Bound = ci_result[2],
    Upper_Bound = ci_result[3],
    Source = df_name,
    Var = "spd_swe"
  )
  
  #append new_row to median_ci_results df, the envir arugment specifies that the results should be appended to the df outside the function
  assign("median_ci_results", rbind(median_ci_results, new_row), envir = .GlobalEnv)
}

spd_ci_bounds <- function(df, df_name) {
  #calculate CI for the median of the column of interest
  ci_result <- MedianCI(df$water_day, conf.level = 0.95, sides = "two", method = "exact")
  
  #create new df with results
  new_row <- data.frame(
    Median = ci_result[1],
    Lower_Bound = ci_result[2],
    Upper_Bound = ci_result[3],
    Source = df_name,
    Var = "spd_water_day"
  )
  
  #append new_row to median_ci_results df, the envir arugment specifies that the results should be appended to the df outside the function
  assign("median_ci_results", rbind(median_ci_results, new_row), envir = .GlobalEnv)
}

sad_cmd_ci_bounds <- function(df, df_name) {
  #calculate CI for the median of the column of interest
  ci_result <- MedianCI(df$water_day, conf.level = 0.95, sides = "two", method = "exact")
  
  #create new df with results
  new_row <- data.frame(
    Median = ci_result[1],
    Lower_Bound = ci_result[2],
    Upper_Bound = ci_result[3],
    Source = df_name,
    Var = NA
  )
  
  #append new_row to median_ci_results df, the envir arugment specifies that the results should be appended to the df outside the function
  assign("median_ci_results", rbind(median_ci_results, new_row), envir = .GlobalEnv)
}

sar_smr_as_ms_ci_bounds <- function(df, df_name) {
  #calculate CI for the median of the column of interest
  ci_result <- MedianCI(df$value, conf.level = 0.95, sides = "two", method = "exact")
  
  #create new df with results
  new_row <- data.frame(
    Median = ci_result[1],
    Lower_Bound = ci_result[2],
    Upper_Bound = ci_result[3],
    Source = df_name,
    Var = NA
  )
  
  #append new_row to median_ci_results df, the envir arugment specifies that the results should be appended to the df outside the function
  assign("median_ci_results", rbind(median_ci_results, new_row), envir = .GlobalEnv)
} #these variables share the same function because the values are all stored in a column called value


#apply swe median ci function to peak date dfs (need to apply both swe and spd functions in this case)

#list all the peak date dfs to which the median ci functions should be applied
spd_df_list <- list(wrfgcmensemble_historical_spd, wrfgcmensemble_midcentury_spd,
                    wrfgcmensemble_latecentury_spd,ins_spd, era5_spd)

#list the peak date df names 
names(spd_df_list) <- c("wrfgcmensemble_historical_spd", "wrfgcmensemble_midcentury_spd",
                        "wrfgcmensemble_latecentury_spd", "ins_historical_spd", "era5_historical_spd")

#loop through each df in list to apply swe median ci function
for (i in seq_along(spd_df_list)) {
  swe_ci_bounds(spd_df_list[[i]], names(spd_df_list)[i]) #the names portion grabs the input df name
}

#loop through each df in list to apply water day median ci function
for (i in seq_along(spd_df_list)) {
  spd_ci_bounds(spd_df_list[[i]], names(spd_df_list)[i])
}





#apply swe median ci function to start date dfs (need to apply sad_cmd function in this case)

#list all the peak date dfs to which the median ci functions should be applied
sad_df_list <- list(wrfgcmensemble_historical_sad, wrfgcmensemble_midcentury_sad,
                    wrfgcmensemble_latecentury_sad,ins_sad, era5_sad)

#list the peak date df names 
names(sad_df_list) <- c("wrfgcmensemble_historical_sad", "wrfgcmensemble_midcentury_sad",
                        "wrfgcmensemble_latecentury_sad", "ins_historical_sad", "era5_historical_sad")

#loop through each df in list to apply water day median ci function
for (i in seq_along(sad_df_list)) {
  sad_cmd_ci_bounds(sad_df_list[[i]], names(sad_df_list)[i])
}



#apply swe median ci function to melt date dfs (need to apply sad_cmd function in this case)

#list all the peak date dfs to which the median ci functions should be applied
cmd_df_list <- list(wrfgcmensemble_historical_cmd, wrfgcmensemble_midcentury_cmd,
                    wrfgcmensemble_latecentury_cmd,ins_cmd, era5_cmd)

#list the peak date df names 
names(cmd_df_list) <- c("wrfgcmensemble_historical_cmd", "wrfgcmensemble_midcentury_cmd",
                        "wrfgcmensemble_latecentury_cmd", "ins_historical_cmd", "era5_historical_cmd")

#loop through each df in list to apply water day median ci function
for (i in seq_along(cmd_df_list)) {
  sad_cmd_ci_bounds(cmd_df_list[[i]], names(cmd_df_list)[i])
}



#apply swe median ci function to accumulation rate dfs (need to apply sar_smr function in this case)

#list all the peak date dfs to which the median ci functions should be applied
sar_df_list <- list(wrfgcmensemble_historical_sar, wrfgcmensemble_midcentury_sar,
                    wrfgcmensemble_latecentury_sar,ins_sar, era5_sar)

#list the peak date df names 
names(sar_df_list) <- c("wrfgcmensemble_historical_sar", "wrfgcmensemble_midcentury_sar",
                        "wrfgcmensemble_latecentury_sar", "ins_historical_sar", "era5_historical_sar")

#loop through each df in list to apply water day median ci function
for (i in seq_along(sar_df_list)) {
  sar_smr_as_ms_ci_bounds(sar_df_list[[i]], names(sar_df_list)[i])
}


#apply swe median ci function to melt rate dfs (need to apply sar_smr function in this case)

#list all the peak date dfs to which the median ci functions should be applied
smr_df_list <- list(wrfgcmensemble_historical_smr, wrfgcmensemble_midcentury_smr,
                    wrfgcmensemble_latecentury_smr,ins_smr, era5_smr)

#list the peak date df names 
names(smr_df_list) <- c("wrfgcmensemble_historical_smr", "wrfgcmensemble_midcentury_smr",
                        "wrfgcmensemble_latecentury_smr", "ins_historical_smr", "era5_historical_smr")

#loop through each df in list to apply water day median ci function
for (i in seq_along(smr_df_list)) {
  sar_smr_as_ms_ci_bounds(smr_df_list[[i]], names(smr_df_list)[i])
}



#apply swe median ci function to accumulation season length dfs (need to apply sar_smr function in this case)

#list all the peak date dfs to which the median ci functions should be applied
as_df_list <- list(wrfgcmensemble_historical_as, wrfgcmensemble_midcentury_as,
                    wrfgcmensemble_latecentury_as, ins_as, era5_as)

#list the peak date df names 
names(as_df_list) <- c("wrfgcmensemble_historical_as", "wrfgcmensemble_midcentury_as",
                        "wrfgcmensemble_latecentury_as", "ins_historical_as", "era5_historical_as")

#loop through each df in list to apply water day median ci function
for (i in seq_along(as_df_list)) {
  sar_smr_as_ms_ci_bounds(as_df_list[[i]], names(as_df_list)[i])
}


#apply swe median ci function to melt season length dfs (need to apply sar_smr function in this case)

#list all the peak date dfs to which the median ci functions should be applied
ms_df_list <- list(wrfgcmensemble_historical_ms, wrfgcmensemble_midcentury_ms,
                    wrfgcmensemble_latecentury_ms,ins_ms, era5_ms)

#list the peak date df names 
names(ms_df_list) <- c("wrfgcmensemble_historical_ms", "wrfgcmensemble_midcentury_ms",
                        "wrfgcmensemble_latecentury_ms", "ins_historical_ms", "era5_historical_ms")

#loop through each df in list to apply water day median ci function
for (i in seq_along(ms_df_list)) {
  sar_smr_as_ms_ci_bounds(ms_df_list[[i]], names(ms_df_list)[i])
}



######plotting data#######

#the dfs with mean, median, and sd values are spd_swe_df, timing_df, durations_df, and rates_df
#the df with the upper and lower bounds of the median 95% CIs is median_ci_results

#name the median column in the median_ci_results df something different so it can be distinguished when datasets are joined
median_ci_results <- median_ci_results %>%
  rename(median_desctools = Median,
         upper = Upper_Bound,
         lower = Lower_Bound)


#split the Source column into three new columns by underscore delimiters
median_ci_results <- median_ci_results %>%
  separate(Source, into = c("source", "period", "var"), sep = "_")

#change naming convetions in values of source 
median_ci_results <- median_ci_results %>%
  mutate(source = as.character(source)) %>%
  mutate(source = case_when(
    source == "wrfgcmensemble" ~ "wrf_gcm", #target is wrf_gcm
    source == "ins" ~ "instrumental", #target is instrumental
    TRUE ~ source #this keeps values of source that are not wrfgcmensemble unchanged
  ))

#change naming convetions in values of period 
median_ci_results <- median_ci_results %>%
  mutate(period = as.character(period)) %>%
  mutate(period = case_when(
    period == "midcentury" ~ "mid-century", 
    period == "latecentury" ~ "end-of-century", 
    TRUE ~ period #this keeps values of source that are not wrfgcmensemble unchanged
  ))

#adjust the values of var to reflect the distinction between spd and spd_swe, then drop the duplicative Var column
median_ci_results <- median_ci_results %>%
  mutate(var = case_when(
    Var == "spd_swe" ~ Var, #replace var with Var when Var is "spd_swe"
    TRUE ~ var #keep other values of var unchanged 
  ))
  
#drop the var column
median_ci_results <- median_ci_results %>%
  select(-Var)

#ensure var source and period are all character type in the dfs of interest
median_ci_results <- median_ci_results %>%
  mutate(var = as.character(var),
         source = as.character(source),
         period = as.character(period))

spd_swe_df <- spd_swe_df %>%
  mutate(var = as.character(var),
         source = as.character(source),
         period = as.character(period))

timing_df <- timing_df %>%
  mutate(var = as.character(var),
         source = as.character(source),
         period = as.character(period))

durations_df <- durations_df %>%
  mutate(var = as.character(var),
         source = as.character(source),
         period = as.character(period))

rates_df <- rates_df %>%
  mutate(var = as.character(var),
         source = as.character(source),
         period = as.character(period))

#join the upper and lower bound values to each results df 
spd_swe_df <- spd_swe_df %>% left_join(median_ci_results, by = c("var", "source", "period")) 
timing_df <- timing_df %>% left_join(median_ci_results, by = c("var", "source", "period")) 
durations_df <- durations_df %>% left_join(median_ci_results, by = c("var", "source", "period")) 
rates_df <- rates_df %>% left_join(median_ci_results, by = c("var", "source", "period"))


##create subsets of the four like-unit dfs for each plot type (one compares date types within hist period, one compares wrf-gcm in future periods)
spd_swe_hist_df <- subset(spd_swe_df, period == "historical")
spd_swe_wrfgcm_df <- subset(spd_swe_df, source == "wrf_gcm")
timing_hist_df <- subset(timing_df, period == "historical")
timing_wrfgcm_df <- subset(timing_df, source == "wrf_gcm")
durations_hist_df <- subset(durations_df, period == "historical")
durations_wrfgcm_df <- subset(durations_df, source == "wrf_gcm")
rates_hist_df <- subset(rates_df, period == "historical")
rates_wrfgcm_df <- subset(rates_df, source == "wrf_gcm")

#re-order the period column so that wrf-gcm plot data are plotted from left to right: historical, mid-century, end-of-century
spd_swe_wrfgcm_df$period <- factor(spd_swe_wrfgcm_df$period, 
                                   levels = c("end-of-century", "mid-century", "historical"))
timing_wrfgcm_df$period <- factor(timing_wrfgcm_df$period, 
                                   levels = c("end-of-century", "mid-century", "historical"))
durations_wrfgcm_df$period <- factor(durations_wrfgcm_df$period, 
                                   levels = c("end-of-century", "mid-century", "historical"))
rates_wrfgcm_df$period <- factor(rates_wrfgcm_df$period, 
                                   levels = c("end-of-century", "mid-century", "historical"))

#re-order the data types in historical period from left to right: instrumental, era5, wrf-gcm
spd_swe_hist_df$source <- factor(spd_swe_hist_df$source,
                                   levels = c("wrf_gcm", "era5", "instrumental"))
timing_hist_df$source <- factor(timing_hist_df$source, 
                                  levels = c("wrf_gcm", "era5", "instrumental"))
durations_hist_df$source <- factor(durations_hist_df$source, 
                                     levels = c("wrf_gcm", "era5", "instrumental"))
rates_hist_df$source <- factor(rates_hist_df$source, 
                                 levels = c("wrf_gcm", "era5", "instrumental"))

# Reorder the var column 
timing_hist_df$var <- factor(timing_hist_df$var, levels = c("cmd", "spd", "sad"))
timing_wrfgcm_df$var <- factor(timing_wrfgcm_df$var, levels = c("cmd", "spd", "sad"))
durations_hist_df$var <- factor(durations_hist_df$var, levels = c("ms", "as"))
durations_wrfgcm_df$var <- factor(durations_wrfgcm_df$var, levels = c("ms", "as"))
rates_hist_df$var <- factor(rates_hist_df$var, levels = c("smr", "sar"))
rates_wrfgcm_df$var <- factor(rates_wrfgcm_df$var, levels = c("smr", "sar"))





#historical comparison of dataset types for spd swe

spd_swe_hist_plot <- ggplot(spd_swe_hist_df, aes(x = median, y = source, fill = source)) +
  geom_col() +
  geom_errorbar(aes(xmin = lower, xmax = upper), linewidth = 0.7, width = 0, color = "black") +
  labs(x = "Median SWE (mm)", y = NULL) +
  scale_fill_manual(values = c("instrumental" = "#ABD9E9",
                               "era5" = "#FFA500",
                               "wrf_gcm" = "#2C7BB6")) +
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, by = 250), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

spd_swe_hist_plot


#future comparison of periods for spd swe
spd_swe_wrf_gcm_plot <- ggplot(spd_swe_wrfgcm_df, aes(y = period, x = median, fill = period)) +
  geom_col() +
  geom_errorbar(aes(xmin = lower, xmax = upper), linewidth = 0.7, width = 0, color = "black") +
  labs(x = "Median SWE (mm)", y = NULL) +
  scale_fill_manual(values = c("historical" = "#2C7BB6",
                               "mid-century" = "#D05E14",
                               "end-of-century" = "#AA1117")) +
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, by = 250), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

spd_swe_wrf_gcm_plot

#historical comparison of data types for timing 
timing_hist_plot <- ggplot(timing_hist_df, aes(y = interaction(source, var), x = median, fill = source)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Timing (water year day)", y = NULL) +
  scale_fill_manual(values = c("instrumental" = "#ABD9E9",
                               "era5" = "#FFA500",
                               "wrf_gcm" = "#2C7BB6")) +
  scale_x_continuous(limits = c(0,300), breaks = seq(0, 300, by = 50), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

timing_hist_plot

#future comparison across periods for timing
timing_wrf_gcm_plot <- ggplot(timing_wrfgcm_df, aes(y = interaction(period, var), x = median, fill = period)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Timing (water year day)", y = NULL) +
  scale_fill_manual(values = c("historical" = "#2C7BB6",
                               "mid-century" = "#D05E14",
                               "end-of-century" = "#AA1117")) +
  scale_x_continuous(limits = c(0, 300), breaks = seq(0, 300, by = 50), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

timing_wrf_gcm_plot

#historical comparison of dataset types for durations 
durations_hist_plot <- ggplot(durations_hist_df, aes(y = interaction(source, var), x = median, fill = source)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Duration (days)", y = NULL) +
  scale_fill_manual(values = c("instrumental" = "#ABD9E9",
                              "era5" = "#FFA500",
                              "wrf_gcm" = "#2C7BB6")) +
  scale_x_continuous(limits = c(0, 150), breaks = seq(0, 150, by = 25), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

durations_hist_plot

#future comparison of durations across periods 
durations_wrf_gcm_plot <- ggplot(durations_wrfgcm_df, aes(y = interaction(period, var), x = median, fill = period)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Duration (days)", y = NULL) +
  scale_fill_manual(values = c("historical" = "#2C7BB6",
                               "mid-century" = "#D05E14",
                               "end-of-century" = "#AA1117")) +
  scale_x_continuous(limits = c(0, 150), breaks = seq(0, 150, by = 25), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

durations_wrf_gcm_plot

#historical comparison of rates across dataset types
rates_hist_plot <- ggplot(rates_hist_df, aes(y = interaction(source, var), x = median, fill = source)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Rate (mm/day)", y = NULL) +
  scale_fill_manual(values = c("instrumental" = "#ABD9E9",
                               "era5" = "#FFA500",
                               "wrf_gcm" = "#2C7BB6")) +
  scale_x_continuous(limits = c(0, 12), breaks = seq(0, 12, by = 1), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

rates_hist_plot


# Rates: Future Comparison of WRF-GCM Data Across Periods
rates_wrf_gcm_plot <- ggplot(rates_wrfgcm_df, aes(y = interaction(period, var), x = median, fill = period)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(xmin = lower, xmax = upper), 
                linewidth = 0.7, width = 0, color = "black", 
                position = position_dodge(width = 0.8)) +
  labs(x = "Median Rate (mm/day)", y = NULL) +
  scale_fill_manual(values = c("historical" = "#2C7BB6",
                               "mid-century" = "#D05E14",
                               "end-of-century" = "#AA1117")) +
  scale_x_continuous(limits = c(0, 12), breaks = seq(0, 12, by = 1), expand = c(0, 0)) +
  theme_classic() +
  theme(legend.position = "top", 
        axis.ticks = element_blank(),
        text = element_text(family = "arial", size = 12),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 12), 
        axis.text.x = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 12))

rates_wrf_gcm_plot




####make two panel versions of these plots, one for the historical comparisons and one for the future comparisons####

# Combine all historical comparison plots
dataset_comparison_combined <- ggarrange(
  spd_swe_hist_plot, timing_hist_plot, 
  durations_hist_plot, rates_hist_plot,
  ncol = 2, nrow = 2, labels = c("b", "c", "d", "e"),
  common.legend = TRUE,
  legend = "top"
)

# Combine all future/wrf-gcm comparison plots
period_comparison_combined <- ggarrange(
  spd_swe_wrf_gcm_plot, timing_wrf_gcm_plot, 
  durations_wrf_gcm_plot, rates_wrf_gcm_plot,
  ncol = 2, nrow = 2, labels = c("b", "c", "d", "e"),
  common.legend = TRUE,
  legend = "top"
)

dataset_comparison_combined 
period_comparison_combined

#export the dataset and period comparison panel plots to svg format
dataset_comparison_panel_svg_path <- "C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Figure files/SVG Figure Files/dataset_comparison_panel.svg"
svglite(dataset_comparison_panel_svg_path, width = 6, height = 4)
print(dataset_comparison_combined)
dev.off()

period_comparison_panel_svg_path <- "C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Figure files/SVG Figure Files/period_comparison_panel.svg"
svglite(period_comparison_panel_svg_path, width = 6, height = 4)
print(period_comparison_combined)
dev.off()

#####plot the swe triangles#####

#plot the model ensemble average demarcation dates to compare snowpack water storage across periods
period_comparison_swe_triangle_plot <- ggplot(wrf_gcm_ensemble_period_average_demarc_date_df, aes(x = water_day_median, y = swe_median)) +
  geom_line(aes(group = period, color = period), linewidth = 0.75) +
  scale_x_continuous(name = "Water Day", limits = c(1, 365), breaks = seq(0, 365, by = 60)) +
  scale_y_continuous(name = "Snow Water Equivalent (mm)", limits = c(0, 1000)) +
  scale_color_manual(name = "period",
                     values = c("historical" = "#2C7BB6",
                                "mid-century" = "#D05E14",
                                "end-of-century" = "#AA1117")) +
  theme_classic() +
  theme(text = element_text(family = "arial", size = 14),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 14, color = "black"),  
        legend.text = element_text(size = 14), 
        legend.title = element_text(size = 14),
        axis.ticks = element_blank(),
        legend.position = "top",
        legend.box = "horizontal")
period_comparison_swe_triangle_plot


#filter out only the hindcast values
wrf_gcm_ensemble_period_average_historical_demarc_date_df <- wrf_gcm_ensemble_period_average_demarc_date_df %>%
  filter(period == "historical")


#plot compare model ensemble and instrumental average demarcation dates
model_instrumental_renalysis_comparison_swe_triangle_plot <- ggplot() +
  geom_line(data = wrf_gcm_ensemble_period_average_historical_demarc_date_df, 
            aes(x = water_day_median, y = swe_median, color = "Model Ensemble"), linewidth = 0.75) +
  geom_line(data = instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates, 
            aes(x = water_day_median, y = swe_median, color = "Instrumental"), linewidth = 0.75) +
  geom_line(data = era5_regionaverage_1986_2005_averagedemarcationdates, 
            aes(x = water_day_median, y = swe_median, color = "Reanalysis"), linewidth = 0.75) +
  scale_x_continuous(name = "Water Day", limits = c(1, 365), breaks = seq(0, 365, by = 60)) +
  scale_y_continuous(name = "Snow Water Equivalent (mm)", limits = c(0, 1000)) +
  scale_color_manual(name = "Dataset", 
                     values = c("Model Ensemble" = "#2C7BB6", 
                                "Instrumental" = "#ABD9E9", 
                                "Reanalysis" = "#FFA500")) +
  theme_classic() +
  theme(text = element_text(family = "arial", size = 14),
        axis.title = element_text(size = 14),  # Axis labels
        axis.text = element_text(size = 14, color = "black"),   # Tick labels
        legend.text = element_text(size = 14), # Legend labels
        legend.title = element_text(size = 14), # Legend title
        axis.ticks = element_blank(),
        legend.position = "top",
        legend.box = "horizontal")
model_instrumental_renalysis_comparison_swe_triangle_plot


#export the swe triangle plots to svg format
dataset_comparison_swe_triangle_svg_path <- "C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Figure files/SVG Figure Files/dataset_comparison_swe_triangle.svg"
svglite(dataset_comparison_swe_triangle_svg_path, width = 6, height = 4)
print(model_instrumental_renalysis_comparison_swe_triangle_plot)
dev.off()

period_comparison_swe_triangle_svg_path <- "C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Figure files/SVG Figure Files/period_comparison_swe_triangle.svg"
svglite(period_comparison_swe_triangle_svg_path, width = 6, height = 4)
print(period_comparison_swe_triangle_plot)
dev.off()










####calculate z scores for each wrf-gcm and date/metric#####

#filter out mid and end-century observations 
all_models_hist_period_demarc_date_df <- all_models_all_periods_demarc_date_df %>%
  filter(period == "historical")
  
all_models_hist_period_duration_rate_df <- all_models_all_periods_duration_rate_df %>%
  filter(period == "historical")

#calculate mean water_day and swe for each unique period/label combo
all_models_hist_period_mean_demarc_date_df <- all_models_hist_period_demarc_date_df %>%
  group_by(label, model) %>%
  summarize(swe = mean(swe, na.rm = TRUE), water_day = mean(water_day, na.rm = TRUE)) %>%
  ungroup()

all_models_hist_period_mean_duration_rate_df <- all_models_hist_period_duration_rate_df %>%
  group_by(metric, model) %>%
  summarize(value = mean(value, na.rm = TRUE)) %>%
  ungroup()

#rename columns in the instrumental df before joining to the wrf-gcm df
instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates_renamed <- instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates %>%
  rename(ins_mean_water_day = water_day_mean,
         ins_mean_swe = swe_mean,
         ins_water_day_sd = water_day_sd,
         ins_swe_sd = swe_sd)

instrumental_swe_data_regionaverage_1986_2005_averagedurationrate_renamed <- instrumental_swe_data_regionaverage_1986_2005_averagedurationrate %>%
  rename(ins_mean = mean,
         ins_sd = sd)


instrumental_swe_data_regionaverage_1986_2005_averagedurationrate_renamed <- instrumental_swe_data_regionaverage_1986_2005_averagedurationrate_renamed %>%
  mutate(
    metric = case_when(
      metric == "as" ~ "as_duration",
      metric == "ms" ~ "ms_duration",
      metric == "sar" ~ "sar_value",
      metric == "smr" ~ "smr_value"
    )
  )

#join the demarcation date dfs on label and the duration rate dfs on metric
z_scores_demarc_date <- all_models_hist_period_mean_demarc_date_df %>%
  left_join(instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates_renamed, by = "label")

z_scores_duration_rate <- all_models_hist_period_mean_duration_rate_df %>%
  left_join(instrumental_swe_data_regionaverage_1986_2005_averagedurationrate_renamed, by = "metric")

#transform the demarcation date z score df so that there is only label and value, as opposed to keeping swe and water day values in separate columns
z_scores_demarc_date_filtered <- z_scores_demarc_date %>%
  pivot_longer(
    cols = c(swe, water_day), #these are the two columns that are going to be reshaped
    names_to = "metric", #swe or water_day is put here 
    values_to = "value" #the values are put here
  ) %>% #the filtering steps below keep only spd swe values, spd water day values, sad water day values, and cmd water day values
  filter(
    (label == "spd" & metric == "swe") |
      (label == "spd" & metric == "water_day") |
      (label == "sad" & metric == "water_day") |
      (label == "cmd" & metric == "water_day")
  )

#combine the label (spd/sad/cmd) and the units (swe/water day) in a new column called variable 
z_scores_demarc_date_filtered <- z_scores_demarc_date_filtered %>%
  mutate(variable = paste(label, metric, sep = "_"))

#separate out the demarcation date df into two dfs based on like units
z_scores_spd_swe_df <- z_scores_demarc_date_filtered %>%
  filter(variable == "spd_swe")

z_scores_dates_df <- z_scores_demarc_date_filtered %>%
  filter(variable == "sad_water_day" | variable == "spd_water_day" | variable == "cmd_water_day")

#calculate the z scores
z_scores_spd_swe_df <- z_scores_spd_swe_df %>%
  mutate(z_score = (value - ins_mean_swe)/ ins_swe_sd)

z_scores_dates_df <- z_scores_dates_df %>%
  mutate(z_score = (value - ins_mean_water_day)/ins_water_day_sd)

#calculate z scores for durations and rates
z_scores_duration_rate <- z_scores_duration_rate %>%
  mutate(z_score = (value - ins_mean)/ins_sd)

#change the name of the metric column in the duration rate z score df
z_scores_duration_rate <- z_scores_duration_rate %>%
  rename(variable = metric)

#keep only the model, variable, and z-score columns from each z score df
z_scores_duration_rate <- z_scores_duration_rate %>%
  select(model, variable, z_score)

z_scores_spd_swe_df <- z_scores_spd_swe_df %>%
  select(model, variable, z_score)

z_scores_dates_df <- z_scores_dates_df %>%
  select(model, variable, z_score)

#combine the the three z score dfs
z_scores_combined <- bind_rows(z_scores_duration_rate, z_scores_spd_swe_df, z_scores_dates_df)

#correct the order in which the variables are plotted
variable_order <- c("spd_swe", "sad_water_day", "spd_water_day", "cmd_water_day", "as_duration", "ms_duration", "sar_value", "smr_value")

z_scores_combined <- z_scores_combined %>%
  mutate(variable = factor(variable, levels = variable_order))

#plot z scores
model_diff_from_ins_zscores_plot <- ggplot(z_scores_combined, aes(x = variable, y = model, fill = z_score)) +
  geom_tile(color = "white") + #this geom creates the cells of the table
  scale_fill_gradient2(low = "#aa111f", mid = "white", high = "#2c7bb6", midpoint = 0) + #sets the color gradient
  geom_text(aes(label = sprintf("%.2f", z_score)), color = "black", size = 2.5, family = "Arial", fontface = "bold") + #add text labels
  theme_minimal() +
  theme(axis.text.y = element_text(color = "black", size = 8, family = "Arial", face = "bold"))
model_diff_from_ins_zscores_plot


model_diff_from_ins_z_svg_path <- "C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Figure files/SVG Figure Files/model_diff_from_ins_z.svg"
svglite(model_diff_from_ins_z_svg_path, width = 7.5, height = 6)
print(model_diff_from_ins_zscores_plot)
dev.off()




###clean up the table that contains final results

#bind the spd_swe, timing, durations, and rates dfs together for one clean results table
all_dates_all_metrics_results <- bind_rows(spd_swe_df, timing_df, durations_df, rates_df)

#start with the naming of values in the var column
all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "spd_swe",
  "Peak Date SWE (mm)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "as",
  "Accumulation Season (days)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "ms",
  "Melt Season (days)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "sad",
  "Start Date (water year day)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "spd",
  "Peak Date (water year day)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "cmd",
  "Melt Date (water year day)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "sar",
  "Accumulation Rate (mm/day)",
  all_dates_all_metrics_results$var
)

all_dates_all_metrics_results$var <- ifelse(
  all_dates_all_metrics_results$var == "smr",
  "Melt Rate (mm/day)",
  all_dates_all_metrics_results$var
)

#naming of values in the source column
all_dates_all_metrics_results$source <- ifelse(
  all_dates_all_metrics_results$source == "instrumental",
  "Instrumental",
  all_dates_all_metrics_results$source
)

all_dates_all_metrics_results$source <- ifelse(
  all_dates_all_metrics_results$source == "wrf_gcm",
  "WRF-GCM Ensemble",
  all_dates_all_metrics_results$source
)

all_dates_all_metrics_results$source <- ifelse(
  all_dates_all_metrics_results$source == "era5",
  "WRF-ERA5",
  all_dates_all_metrics_results$source
)

#naming of values in the source column
all_dates_all_metrics_results$period <- ifelse(
  all_dates_all_metrics_results$period == "historical",
  "Historical",
  all_dates_all_metrics_results$period
)

all_dates_all_metrics_results$period <- ifelse(
  all_dates_all_metrics_results$period == "mid-century",
  "Mid-Century",
  all_dates_all_metrics_results$period
)

all_dates_all_metrics_results$period <- ifelse(
  all_dates_all_metrics_results$period == "end-of-century",
  "End-of-Century",
  all_dates_all_metrics_results$period
)

#drop the median_desctools column
all_dates_all_metrics_results <- all_dates_all_metrics_results %>%
  select(-median_desctools)

#rename columns
all_dates_all_metrics_results <- all_dates_all_metrics_results %>%
  rename("Median 95% CI Lower Bound" = "lower") %>%
  rename("Median 95% CI Upper Bound" = "upper") %>%
  rename("Variable" = "var") %>%
  rename("Mean" = "mean") %>%
  rename("Median" = "median") %>%
  rename("Period" = "period") %>%
  rename("Standard Deviation" = "sd") %>%
  rename("Dataset" = "source")

#reorder column names
all_dates_all_metrics_results <- all_dates_all_metrics_results %>%
  select(Variable, Dataset, Period, Mean, Median, `Standard Deviation`, 
         `Median 95% CI Upper Bound`, `Median 95% CI Lower Bound`)

#add new column for % change from historical to future period
#only applies to obs for which Dataset is WRF-GCM ensemble and Period is Mid-Century or End-of-Century
all_dates_all_metrics_results <- all_dates_all_metrics_results %>%
  group_by(Variable) %>%
  mutate(`Proportion of Historical Period Value (%)` = case_when(
    Dataset == "WRF-GCM Ensemble" & Period %in% c("Mid-Century", "End-of-Century") ~
      (Median / Median[Period == "Historical" & Dataset == "WRF-GCM Ensemble"]) * 100,
    TRUE ~ NA_real_ #puts NA in other rows
  )) %>% 
  ungroup()


#######prepare swe triangle for each wrf-gcm############

#this is the list that contains data from just before calculating model ensemble values in the script above
head(all_models_all_periods_demarc_dates_list[[1]])
head(all_models_all_periods_demarc_dates_list[[16]])
head(all_models_all_periods_demarc_dates_list[[31]])

#this df shows the structure of the input needed for the swe triangle plotting code
head(wrf_gcm_ensemble_period_average_historical_demarc_date_df)

#create the new lists to which dfs that contain all periods for one model are placed
#the dfs in the list above contained a different df for each period (e.g. three dfs per wrf-gcm)
all_models_periods_combined_demarc_date_list <- list()

#combine all dfs in the all_models_all_periods_demarc_dates_list list into one df
all_models_all_periods_demarc_dates_df <- do.call(rbind, all_models_all_periods_demarc_dates_list)

#get unique model names in all_models_all_periods_demarc_dates_df
unique_models <- unique(all_models_all_periods_demarc_dates_df$model)

#loop thru each model to extract observations for each model and put them in a new df within the new list
for (model_name in unique_models) {
  all_models_periods_combined_demarc_date_list[[model_name]] <- all_models_all_periods_demarc_dates_df[all_models_all_periods_demarc_dates_df$model == model_name, ]
}

#define function to compute interannual swe and water day medians from the list with data by wrf-gcm
compute_interannual_medians_fxn <- function(df) {
  df %>%
    group_by(model,period, label) %>% #label contains sad, spd, and cmd
    summarize(swe_median = median(swe), water_day_median = median(water_day)) %>%
    ungroup()
}

#apply function to each df in the list (this gives a new list the contains 15 dfs
#each df containing interannual median swe and water day for sad, spd, and cmd for a single wrf-gcm )
all_models_demarc_date_median_list <- lapply(all_models_periods_combined_demarc_date_list, compute_interannual_medians_fxn)


##filter out only the hindcast values

#define function
filter_for_hist_values_fxn <- function(df) {
  df %>% 
    filter(period == "historical")
}

all_models_demarc_date_median_list_hist <- lapply(all_models_demarc_date_median_list, filter_for_hist_values_fxn)

##now plot the swe triangles for each of the df in the all_models_demarc_date_median_list

#define function to plot swe triangles for each wrf-gcm in the future period

wrf_gcm_future_swe_triangle_plot_fxn <- function(df) {
  #extract model name from the the input df
  model_name <- unique(df$model)
  
  #now plot
  ggplot(df, aes(x = water_day_median, y = swe_median)) +
    geom_line(aes(group = period, color = period), linewidth = 0.5) +
    scale_x_continuous(name = "Water Day", limits = c(1, 365), breaks = seq(0, 365, by = 60)) +
    scale_y_continuous(name = "SWE (mm)", limits = c(0, 1200)) +
    scale_color_manual(name = "period",
                       values = c("historical" = "#2C7BB6",
                                  "mid-century" = "#D05E14",
                                  "end-of-century" = "#AA1117")) +
    ggtitle(model_name) + #adds plot title based on model name 
    theme_classic() +
    theme(text = element_text(family = "arial", size = 12),
          axis.title = element_text(size = 12),
          axis.title.y = element_text(hjust = 1, vjust = 1, margin = margin(r = 10)),
          axis.text = element_text(size = 10, color = "black"),  
          axis.text.x = element_text(angle = 45, hjust = 1), #tilts x axis text to fit 
          legend.text = element_text(size = 12), 
          legend.title = element_text(size = 12),
          axis.ticks = element_blank(),
          legend.position = "top",
          legend.box = "horizontal")
}

#create the plots
wrf_gcm_future_plots_list <- map(all_models_demarc_date_median_list, wrf_gcm_future_swe_triangle_plot_fxn)

#put all 15 plots in a 15 panel
wrf_gcm_future_panel <- ggarrange(
  plotlist = wrf_gcm_future_plots_list,
  ncol = 3, nrow = 5,
  common.legend = TRUE,
  legend = "top"
)


#define function to plot swe triangles for each wrf-gcm in the historical period against instrumental and wrf-era5 values
wrf_gcm_historical_swe_triangle_plot_fxn <- function(df) {
  model_name <- unique(df$model)
  ggplot() +
    geom_line(data = df, 
              aes(x = water_day_median, y = swe_median, color = "WRF-GCM"), linewidth = 0.5) +
    geom_line(data = instrumental_swe_data_regionaverage_1986_2005_averagedemarcationdates, 
              aes(x = water_day_median, y = swe_median, color = "Instrumental"), linewidth = 0.5) +
    geom_line(data = era5_regionaverage_1986_2005_averagedemarcationdates, 
              aes(x = water_day_median, y = swe_median, color = "Reanalysis"), linewidth = 0.5) +
    scale_x_continuous(name = "Water Day", limits = c(1, 365), breaks = seq(0, 365, by = 60)) +
    scale_y_continuous(name = "SWE (mm)", limits = c(0, 1200)) +
    scale_color_manual(name = "Dataset", 
                       values = c("WRF-GCM" = "#2C7BB6", 
                                  "Instrumental" = "#ABD9E9", 
                                  "Reanalysis" = "#FFA500")) +
    ggtitle(model_name) + #adds plot title based on model name 
    theme_classic() +
    theme(text = element_text(family = "arial", size = 12),
          axis.title = element_text(size = 12),  # Axis labels
          axis.title.y = element_text(hjust = 1, vjust = 1, margin = margin(r = 10)),
          axis.text = element_text(size = 10, color = "black"),   # Tick labels
          axis.text.x = element_text(angle = 45, hjust = 1), #tilts x axis text to fit 
          legend.text = element_text(size = 12), # Legend labels
          legend.title = element_text(size = 12), # Legend title
          axis.ticks = element_blank(),
          legend.position = "top",
          legend.box = "horizontal")
}

#plot the historical plots for individual wrf-gcm
wrf_gcm_historical_plots_list <- map(all_models_demarc_date_median_list_hist, wrf_gcm_historical_swe_triangle_plot_fxn)

#put all 15 plots in a 15 panel
wrf_gcm_historical_panel <- ggarrange(
  plotlist = wrf_gcm_historical_plots_list,
  ncol = 3, nrow = 5,
  common.legend = TRUE,
  legend = "top"
)

#export the swe triangle plots to svg format
wrf_gcm_historical_panel_path <- "C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Figure files/SVG Figure Files/wrf_gcm_historical_panel.svg"
svglite(wrf_gcm_historical_panel_path, width = 6.5, height = 8)
print(wrf_gcm_historical_panel)
dev.off()

wrf_gcm_future_panel_path <- "C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Figure files/SVG Figure Files/wrf_gcm_future_panel.svg"
svglite(wrf_gcm_future_panel_path, width = 6.5, height = 8)
print(wrf_gcm_future_panel)
dev.off()




###prepare table with final results####

#drop unwanted column in final table
all_dates_all_metrics_results_minus_proportion <- all_dates_all_metrics_results %>%
  select(-`Proportion of Historical Period Value (%)`)

#set columns as numeric
all_dates_all_metrics_results_minus_proportion$Mean <-
  as.numeric(all_dates_all_metrics_results_minus_proportion$Mean)
all_dates_all_metrics_results_minus_proportion$Median <-
  as.numeric(all_dates_all_metrics_results_minus_proportion$Median)
all_dates_all_metrics_results_minus_proportion$`Standard Deviation` <-
  as.numeric(all_dates_all_metrics_results_minus_proportion$`Standard Deviation`)
all_dates_all_metrics_results_minus_proportion$`Median 95% CI Upper Bound` <-
  as.numeric(all_dates_all_metrics_results_minus_proportion$`Median 95% CI Upper Bound`)
all_dates_all_metrics_results_minus_proportion$`Median 95% CI Lower Bound` <-
  as.numeric(all_dates_all_metrics_results_minus_proportion$`Median 95% CI Lower Bound`)

#round numeric columns to one decimal place
all_dates_all_metrics_results_minus_proportion <- all_dates_all_metrics_results_minus_proportion %>%
  mutate_if(is.numeric, ~round(., 1)) #round all numeric column values to one decimal place


#create word document and add table
doc <- read_docx() %>%
  body_add_flextable(
    flextable(all_dates_all_metrics_results_minus_proportion) %>%
      autofit() %>% #adjust column width to fit on 8.5x11 page
      set_table_properties(width = 1, layout = "autofit") #ensures table uses full width of page
  )

#save the document
print(doc, target = "final_results.docx")



###make a table and plot of the sampling point elevations and corresponding wrf grid cells


wrf_grid_elev_df <- read.csv("C:/Users/DavGreenspan/Box/Preparing for Uncertain Water Futures Paper/Data files/wrf_grid_cell_elevations.csv")
head(wrf_grid_elev_df)

wrf_grid_cell_elev_plot <- ggplot(wrf_grid_elev_df, aes(x = `Elevation..meters.`, y = `WRF.Elevation..meters.`, label = `Station.Code`)) +
  geom_point(size = 2, color = "black") +  # Plot points
  geom_text(vjust = -0.5, hjust = 0.5) +  # Add station code labels near points
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +  # Add a y=x line
  labs(
    title = NULL,
    x = "Elevation (meters)",
    y = "WRF Elevation (meters)"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),  # Removes major grid lines
    panel.grid.minor = element_blank()  # Removes minor grid lines
  )

wrf_grid_cell_elev_plot

ggsave("C:/Users/DavGreenspan/Box/Greenspan Sierra water paper/Figure files/PNG and JPG figure files/Results figs for GRL paper resubmission/wrf_grid_cell_elev_plot.png", 
       plot = wrf_grid_cell_elev_plot,
       width = 6, height = 4,
       units = "in",
       device = "png")

##analyze the elevations of the sampling points relative to the wrf grid points

# Count the number of observations where wrf_elev_meters > elev_meters
count_wrf_greater <- sum(wrf_grid_elev_df$wrf_elev_meters > wrf_grid_elev_df$elev_meters)

# Count the number of observations where wrf_elev_meters < elev_meters
count_elev_greater <- sum(wrf_grid_elev_df$wrf_elev_meters < wrf_grid_elev_df$elev_meters)

count_wrf_greater
count_elev_greater

station_elev_mean <- mean(wrf_grid_elev_df$elev_meters)
station_elev_median <- median(wrf_grid_elev_df$elev_meters)  

station_elev_mean
station_elev_median

wrf_elev_mean <- mean(wrf_grid_elev_df$wrf_elev_meters)
wrf_elev_median <- median(wrf_grid_elev_df$wrf_elev_meters)

wrf_elev_mean
wrf_elev_median

station_elev_mean - wrf_elev_mean
station_elev_median - wrf_elev_median
