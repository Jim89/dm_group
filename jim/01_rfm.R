# Step 0 - prep env -------------------------------------------------------

# Define function to pull through specific customers from the db based on table
get_custs <- function(table_name) {
    tbl(db, table_name) %>% select(cust_id) %>% distinct()
}    

# Define function to, given a set of customers, return the rfm segments for them
cust_rfm <- function(customers) {
    # Compute r
    r <- lines %>%
        inner_join(customers) %>% 
        group_by(cust_id) %>% 
        summarise(most_recent = max(order_date)) %>% 
        collect() %>% 
        mutate(age = difftime("2008-01-01", most_recent, units = "days"),
               age = as.numeric(age),
               r = ntile(age, 5))
    
    # Compute f
    f <- lines %>% 
        inner_join(customers) %>% 
        group_by(cust_id) %>% 
        summarise(purchases = n()) %>% 
        collect() %>% 
        mutate(f = ntile(purchases, 5))
    
    # Compute m
    m <- lines %>% 
        inner_join(customers) %>% 
        group_by(cust_id) %>% 
        summarise(avg_spend = mean(line_dollars)) %>% 
        collect() %>% 
        mutate(m = ntile(avg_spend, 5))
    
    # Combine and return
    rfm <- r %>% 
        left_join(f) %>% 
        left_join(m) %>% 
        select(cust_id, r, f, m) %>% 
        rowwise() %>% 
        mutate(rfm = paste(r, f, m, sep = ""))
    
    return(rfm)   
}    


# Step 1 - get rfm for each data split ------------------------------------
# Emailed customers
email_1_rfm <- get_custs("email_first_half") %>% cust_rfm()
email_2_rfm <- get_custs("email_second_half") %>% cust_rfm()

# Catalogue customers
cat_1_rfm <- get_custs("cat_first_half") %>% cust_rfm()
cat_2_rfm <- get_custs("cat_second_half") %>% cust_rfm()
