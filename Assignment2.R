#Ruochen Qiu
#This file is an exploratory analysis of the DoT FARS data.


#############Open RStudio and Install Pertinent Packages###################

library(readr)
library(haven)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

#############Load the FARS Data into R###################

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
# Step by step
agg <- acc %>%
         group_by(StateName,YEAR) %>%
         summarise(TOTAL = sum(FATALS))

agg_wide <-agg %>% spread(YEAR, TOTAL)
agg_wide <- rename(agg_wide, "Year2014" = '2014', "Year2015" = '2015')

agg_wide <- agg_wide %>% mutate(Diff_Percent = (Year2015-Year2014)/((Year2014+Year2014)/2))

agg_wide <- arrange(agg_wide, Diff_Percent)

agg_wide <- agg_wide %>%
              filter(!is.na(StateName))

agg <- agg_wide %>%
              filter(Diff_Percent > 0.15 )
glimpse(agg)


#The whole chain
agg_wide <-acc %>%
            group_by(StateName,YEAR) %>%
            summarise(TOTAL = sum(FATALS))%>% spread(YEAR, TOTAL) %>%
            rename("Year2014" = '2014', "Year2015" = '2015')%>% 
            mutate(Diff_Percent = (Year2015-Year2014)/((Year2014+Year2014)/2)) %>%
            arrange(Diff_Percent) %>%
            filter(!is.na(StateName))%>%
            filter(Diff_Percent > 0.15 ) %>%glimpse
