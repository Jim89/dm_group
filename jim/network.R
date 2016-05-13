# Step 0 - prep env -------------------------------------------------------
library(networkD3)
library(igraph)

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
    left_join(outdeg) %>% 
    mutate(out_deg = ifelse(is.na(out_deg), 0, out_deg),
           od = ntile(out_deg, 5))

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


# Step 4 - clean up -------------------------------------------------------
rm(to_plot, nw)
gc()

