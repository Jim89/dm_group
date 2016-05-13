# Step 0 - prep env -------------------------------------------------------

# Function to count orders per customer
orders_per_cust <- function(data) {
    data %>% 
        select(cust_id, ordernum) %>% 
        distinct() %>% 
        group_by(cust_id) %>% 
        summarise(orders = n())
}


# Step 1 - apply function to get orders per cust --------------------------
# Emailed customers
email_1_orders <- orders_per_cust(email_1_att)
email_2_orders <- orders_per_cust(email_2_att)

# Catalogue customers
cat_1_orders <- orders_per_cust(cat_1_att)
cat_2_orders <- orders_per_cust(cat_2_att)

# Step 2 - clean up -------------------------------------------------------

rm(orders_per_cust)
gc()


