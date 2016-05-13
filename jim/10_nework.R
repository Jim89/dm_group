# Step 0 - prep env -------------------------------------------------------

# Step 1 - prepare data ---------------------------------------------------
graph_data <- lines %>%
              select(cust_id, ordernum, recipnum) %>% 
              filter(recipnum != '' &
                     cust_id != recipnum) %>% 
              group_by(cust_id, recipnum) %>% 
              summarise(weight = n()) %>% 
              collect()

# Step 2 - make graph and extract info ------------------------------------
# Make the graph
graph <- graph_from_data_frame(graph_data)

# Extract out-degree of gift-giving
outdeg <- degree(graph, mode = "out") %>% 
            data.frame() %>% 
            add_rownames("cust_id") %>% 
            dplyr::as_data_frame() %>% 
            rename_(out_deg = '.')

# Clean up graph object
rm(graph)

# Ensure we have out-degree for all customers
outdeg <- sum_tabl %>% 
    select(cust_id) %>% 
    collect() %>% 
    left_join(outdeg, by = c("cust_id" = "cust_id")) %>% 
    mutate(out_deg = ifelse(is.na(out_deg), 0, out_deg),
           od = ntile(out_deg, 5))

# Write to db if it doesn't exist
if(sum(class(tbl(db, "outdeg")) == "tbl_sql") == 0) {
outdeg <- copy_to(db, outdeg, temporary = FALSE)
}
# Step 3 - visualise ------------------------------------------------------
# Subset the data slightly
to_plot <- graph_data %>% filter(weight >= 5) %>% 
            bind_rows(graph_data %>% filter(cust_id == "33784549")) %>% 
            distinct()

# Make the graph object
graph <- graph_from_data_frame(to_plot)

# Set up networkD3 graph data, setting all nodes to be in same group/cluster
nw <- igraph_to_networkD3(graph, group = rep(1, V(graph) %>% length()))

# Weight links by number of gifts sent
nw$links$value <- E(graph)$weight

# Plot the network
net <- forceNetwork(Links = nw$links,
             Nodes = nw$nodes,
             colourScale = JS("d3.scale.category20()"),
             Source = "source",
             Target = "target",
             Value = "value",
             NodeID = "name",
             Group = "group",
             charge = -250,
             linkColour = "grey",
             opacity = 1,
             legend = F,
             bounded = F,
             zoom = TRUE)

# Step 4 - Visualise reln between gifts and spend -------------------------
purchase_stats <- orders %>% 
    group_by(cust_id) %>% 
    summarise(orders = n()) %>% 
    left_join(lines %>% group_by(cust_id) %>% summarise(spend = sum(line_dollars))) %>% 
    collect()

purchase_stats <- outdeg %>% 
    left_join(purchase_stats, by = c("cust_id" = "cust_id"))

gift_spend_rel <- purchase_stats %>% 
    ggplot(aes(x = out_deg, y = spend)) +
    geom_point(aes(size = orders), colour = "steelblue", alpha = 0.5) +
    scale_y_continuous(labels = scales::comma) +
    xlab("Gift recipients (out-degree centrality)") +
    ylab("Total spend (£)") +
    guides(size = guide_legend(title = "Total orders")) +
    geom_smooth(alpha = 0.75, colour = "firebrick") +
    theme_jim

fit <- lm(spend ~ out_deg + orders, data = purchase_stats)
tidy_fit <- broom::tidy(fit)
glance_fit <- broom::glance(fit)

# Step 5 - clean up -------------------------------------------------------
rm(to_plot, nw)
gc()

