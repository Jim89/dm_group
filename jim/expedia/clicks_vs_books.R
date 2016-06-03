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


train_sample <- tbl(db, "train_new_sample")

# Grab the data
data <- train_sample %>% 
    select(srch_id, prop_id, 
           position, 
           price_usd, 
           click_bool, 
           booking_bool, 
           prop_starrating,
           promotion_flag,
           srch_length_of_stay) %>% 
    collect() %>% 
    mutate(price_usd = round(price_usd, 0),
           price_bin = cut(price_usd, 25),
           click_bool = ifelse(click_bool == T, 1, 0),
           booking_bool = ifelse(booking_bool == T, 1, 0),
           action = ifelse(booking_bool == 1, "Book", 
                           ifelse(click_bool == 1 & booking_bool == 0, "Click",
                                  "No action")),
           action = factor(action, levels = c("No action", "Click", "Book")))

# Simple correlations between fields
cors <- cor(data %>% select(position, price_usd, click_bool, booking_bool, promotion_flag))

# Summary of click/book rate per position
rates <- data %>% 
    group_by(position) %>% 
    summarise(click = mean(click_bool),
              book = mean(booking_bool))

# Look at effects of position and price on click and book
click_fit <- glm(click_bool ~ position + price_usd + prop_starrating + srch_length_of_stay, 
                 data = data, family = "binomial")
book_fit <- glm(booking_bool ~ position + price_usd + prop_starrating  + srch_length_of_stay, 
                data = data, family = "binomial")

# Fit multinomial logit for all 3 levels (no action, click, book)
fit <- multinom(action ~ position + price_usd + prop_starrating  + srch_length_of_stay
                , data = data)


# Function for plotting data
gather_and_plot <- function(data, field) {
    data %>% 
        group_by_(field) %>% 
        summarise(click = mean(click_bool),
                  book = mean(booking_bool)) %>% 
        gather_("key", "value", c("click", "book")) %>% 
        ggplot(aes_string(x = field, y = "value", group = "key")) +
        geom_line(aes(colour = key), size = 1.5) +
        facet_grid(key ~ .) +
        scale_y_continuous(labels = scales::percent) +
        xlab(field) +
        ylab("Rate") +
        scale_colour_brewer(palette = "Dark2") +
        theme_jim
}

gather_and_plot(data, "price_bin")

data %>% 
    ggplot(aes(x = price_usd, y = click_bool)) +
    geom_point(colour = "steelblue", size = 2, alpha = 0.75) +
    geom_smooth() +
    theme_jim

data %>% 
    ggplot(aes(x = price_usd, y = booking_bool)) +
    geom_point(colour = "steelblue", size = 2, alpha = 0.75) +
    geom_smooth() +
    theme_jim

