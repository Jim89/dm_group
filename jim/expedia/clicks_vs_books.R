library(dplyr)
library(ggplot2)
library(tidyr)

theme_jim <-  theme(legend.position = "bottom",
                    axis.text.y = element_text(size = 16, colour = "black"),
                    axis.text.x = element_text(size = 16, colour = "black"),
                    legend.text = element_text(size = 16),
                    legend.title = element_text(size = 16),
                    title = element_text(size = 16),
                    strip.text = element_text(size = 16, colour = "black"),
                    strip.background = element_rect(fill = "white"),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
                    panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
                    panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
                    panel.margin.y = unit(0.1, units = "in"),
                    panel.background = element_rect(fill = "white", colour = "lightgrey"),
                    panel.border = element_rect(colour = "black", fill = NA))

db <- src_postgres("expedia", user = "postgres", password = pg_password)


data <- tbl(db, "train_new")


clean <- data %>% 
    select(srch_id, prop_id, position, price_usd, click_bool, booking_bool) %>% 
    mutate(price_usd = round(price_usd, 0),
           price_bin = cut(price_usd, 25))


clean %>% 
    group_by(position) %>% 
    summarise(click  = mean(click_bool),
              book = mean(booking_bool)) %>% 
    gather(type, avg, -position) %>% 
    mutate(type = ifelse(type == "book", "Book", "Click")) %>% 
    ggplot(aes(x = position, y = avg, group = type)) +
    geom_point(aes(colour = type)) +
    geom_line(aes(colour = type), size = 1.5) +
    facet_grid(type ~ .) +
    scale_y_continuous(labels = scales::percent) +
    scale_colour_brewer(palette = "Dark2") +
    guides(colour = "none") +
    ylab("Likelihood") +
    theme_jim



clean %>% 
    group_by(price_bin) %>% 
    summarise(click  = mean(click_bool),
              book = mean(booking_bool)) %>% 
    gather(type, avg, -price_bin) %>% 
    mutate(type = ifelse(type == "book", "Book", "Click")) %>% 
    ggplot(aes(x = price_bin, y = avg, group = type)) +
    geom_point(aes(colour = type)) +
    geom_line(aes(colour = type), size = 1.5) +
    facet_grid(type ~ .) +
    scale_y_continuous(labels = scales::percent) +
    scale_colour_brewer(palette = "Dark2") +
    guides(colour = "none") +
    ylab("Likelihood") +
    theme_jim


