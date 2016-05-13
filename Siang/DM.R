library(mlogit)
library(readr)
library(plyr)
library(dplyr)
setwd("~/desktop/DM")

#read files
contacts <- read_csv("DMEFExtractContactsV01.CSV",col_names = TRUE,col_types = NULL,skip=0)
lines <- read_csv("DMEFExtractLinesV01.csv",col_names = TRUE,col_types = NULL,skip=0)
orders <- read_csv("DMEFExtractOrdersV01.CSV",col_names = TRUE,col_types = NULL,skip=0)
summary <- read_csv("DMEFExtractSummaryV01.CSV",col_names = TRUE,col_types = NULL,skip=0)

#Create a function to replace blank with NA
empty_as_na <- function(x){if("factor" %in% class(x)) x <- as.character(x) ifelse(as.character(x)!="", x, NA)}

#Replace blank with NA
contacts<- contacts %>% mutate_each(funs(empty_as_na)) 
linea<- lines %>% mutate_each(funs(empty_as_na)) 
orders<- orders %>% mutate_each(funs(empty_as_na)) 
summary<- summary %>% mutate_each(funs(empty_as_na)) 

#Remove line with no distance data
new_summary <- summary %>% filter(!is.na(StoreDist))

#Calculate subtotal of dollar spent
line_gift <- lines %>% filter(Gift=="Y")
line_nogift <- lines %>% filter(Gift=="N")
line_retail <- lines %>% filter(is.na(Gift))
sum_gift <- line_gift %>% group_by(Cust_ID) %>% summarise(sum_dollar_gift = sum(LineDollars, na.rm = TRUE))
sum_nogift <- line_nogift %>% group_by(Cust_ID) %>% summarise(sum_dollar_nongift = sum(LineDollars, na.rm = TRUE))
sum_retail <- line_retail %>% group_by(Cust_ID) %>% summarise(sum_dollar_retail = sum(LineDollars, na.rm = TRUE))

#Aggregate data on ID level
totalspendbyID <- lines %>% group_by(Cust_ID) %>% summarise(sum_dollar_total = sum(LineDollars, na.rm = TRUE))
storedistancebyID <- new_summary %>% select(Cust_ID,StoreDist)
ordermethodbyID <- read_csv("order_method.csv",col_names = TRUE,col_types = NULL,skip=0)
paymentmethodbyID <- read_csv("payment_method.csv",col_names = TRUE,col_types = NULL,skip=0)

#Join datasets by ID
data<- left_join(totalspendbyID,sum_gift,by = "Cust_ID")
data<- left_join(data,sum_nogift,by = "Cust_ID")
data<- left_join(data,sum_retail,by = "Cust_ID")
data<- left_join(data,storedistancebyID,by = "Cust_ID")
data<- left_join(data,ordermethodbyID,by = "Cust_ID")
data<- left_join(data,paymentmethodbyID,by = "Cust_ID")

new_data <- data %>% filter(!is.na(StoreDist),!is.na(sum_dollar_retail))

#Export data
write.csv(data,file="data.csv")