#Ruochen Qiu
#This file is an exploratory analysis of the DoT FARS data.


#############Load the FARS Data into R###################
#Put them here just to show the process been did for the assignment
#install.packages("readr")
#install.packages("haven")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("stringr")
#install.packages("ggplot2")

library(readr)
library(haven)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

acc2014 <- read_sas("accident.sas7bdat")
acc2015 <- read_csv("accident.csv")

ls()
class(acc2014)
class(acc2015)

############Combining the two years of FARS data############

acc2014 <- acc2014 %>% as_tibble() %>% mutate(
  TWAY_ID2 = na_if(TWAY_ID2, "")
)

table(is.na(acc2014$TWAY_ID2))

dim(acc2014)
dim(acc2015)

colnames(acc2014) %in% colnames(acc2015)
colnames(acc2015) %in% colnames(acc2014)
#"RUR_URB", "FUNC_SYS","RD_OWNER" are not in acc2014 
#"ROAD_FNC" are not in acc 2015

acc <- bind_rows(acc2014, acc2015)
count(acc, RUR_URB)
# The bind_rows function simply bind two tibbles togther without adding anything.
# The reason of get 30056 NA is that no column named RUR_URB exists in "acc2014", when combine these two tibbles, 
# the rows which were belong to acc2014 are showing as NA in new tibble "acc" since there is no such data of RUR_URB in 2014.


############Merging on another data source####################
fips <- read_csv("fips.csv")
glimpse(fips)

acc$STATE <- as.character(as.numeric(acc$STATE))
acc$COUNTY <- as.character(as.numeric(acc$COUNTY))

acc$STATE <- str_pad(acc$STATE, 2, pad = "0")
acc$COUNTY <- str_pad(acc$COUNTY, 3, pad = "0")

acc <- rename(acc, "StateFIPSCode" = "STATE")
acc <- rename(acc, "CountyFIPSCode" = "COUNTY")
acc <- left_join(acc, fips, by = c("StateFIPSCode", "CountyFIPSCode"))

################Exploratory Data Analysis in R’s dplyr and tidyr package############

