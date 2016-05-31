library(readr)
library(dplyr)

test <- read.csv("./data/expedia/test.csv.gz", header = T, stringsAsFactors = F)
submissions <- read.csv("./data/expedia/sample_submission.csv.gz", header = T, stringsAsFactors = F)
destinations <- read.csv("./data/expedia/destinations.csv.gz", header = T, stringsAsFactors = F)
train <- read_csv("./data/expedia/train.csv")

db <- src_postgres("expedia", user = "postgres", password = "gy!be1989")

tmp <- copy_to(db, test, temporary = FALSE)
tmp <- copy_to(db, submissions, temporary = FALSE)
tmp <- copy_to(db, destinations, temporary = FALSE)
