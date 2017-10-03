#Ruochen Qiu
#This file is an exploratory analysis of the DoT FARS data.

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

