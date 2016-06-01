library(dplyr)

db <- src_postgres("expedia", user = "postgres", password = "gy!be1989")

train_sample <- tbl(db, "train_sample")
dest <- tbl(db, "destinations")

train_sample %>% head(100) %>% View




