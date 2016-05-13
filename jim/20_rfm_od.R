# Apply gift logic to catalogues only
rfm_od <- cat_1_rfm %>% 
    left_join(outdeg, by = c("cust_id" = "cust_id")) %>% 
    mutate(rfm_od = paste0(rfm, od)) %>% 
    select(cust_id, rfm_od) %>% 
    rename(rfm = rfm_od)
    

# Catalogue customers
cat_1_rfm_od_stats <- rfm_to_stats(rfm_od, cat_1_contacts, cat_1_orders)
