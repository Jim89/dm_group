# Step 0 - prep env -------------------------------------------------------

# Function to get the contacts per customer in the sample
get_contacts <- function(table_name) {
    tbl(db, table_name) %>% 
        select(cust_id, contact_date) %>% 
        group_by(cust_id) %>% 
        summarise(contacts = n())
}

# Step 1 - get the data ---------------------------------------------------
# Email contacts
email_1_contacts <- get_contacts("email_first_half")
email_2_contacts <- get_contacts("email_second_half")

# Catalogue contacts
cat_1_contacts <- get_contacts("cat_first_half")
cat_2_contacts <- get_contacts("cat_second_half")


# Step 2 - clean up -------------------------------------------------------
rm(get_contacts)
gc()





