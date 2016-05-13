# Step 0 - prep env -------------------------------------------------------

# Create function to combine data summaries in to response rates per rfm
rfm_to_stats <- function(rfm_data, contacts_data, orders_data) {
    rfm_data %>% 
        select(cust_id, rfm) %>% 
        left_join(contacts_data, by = c("cust_id" = "cust_id"), copy = T) %>% 
        left_join(orders_data, by = c("cust_id" = "cust_id"), copy = T) %>% 
        ungroup() %>% 
        group_by(rfm) %>% 
        summarise(contacts = sum(contacts, na.rm = T),
                  orders = sum(orders, na.rm = T)) %>% 
        mutate(response_rate = (orders/contacts)*100)
}

# Step 1 - summarise rfm segments -----------------------------------------
# Emailed customers
email_1_rfm_stats <- rfm_to_stats(email_1_rfm, email_1_contacts, email_1_orders) 
email_2_rfm_stats <- rfm_to_stats(email_2_rfm, email_2_contacts, email_2_orders)

# Catalogue customers
cat_1_rfm_stats <- rfm_to_stats(cat_1_rfm, cat_1_contacts, cat_1_orders) 
cat_2_rfm_stats <- rfm_to_stats(cat_2_rfm, cat_2_contacts, cat_2_orders)

