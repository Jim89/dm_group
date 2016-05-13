
# Step 0 - prep env -------------------------------------------------------

# Function to join segmented contacts table together and find attributable sales
attributable_sales <- function(table_name, interval) {
sql_cmd <- paste0("order_date between contact_date and (contact_date + interval '", interval, " days')")  

tbl(db, table_name) %>% 
    left_join(orders, by = c("cust_id" = "cust_id")) %>% 
    select(cust_id, contact_date, ordernum, order_date) %>% 
    filter_("order_date" >= "contact_date") %>% 
    filter(sql(sql_cmd))
}    


# Step 1 - find attributable sales ----------------------------------------
# Emailed customers - only within 30 days
email_1_att <- attributable_sales("email_first_half", 30)
email_2_att <- attributable_sales("email_second_half", 30)

# Catalogue customers - only within 100 days
cat_1_att <- attributable_sales("cat_first_half", 100)
cat_2_att <- attributable_sales("cat_second_half", 100)


