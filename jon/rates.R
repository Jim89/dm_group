#Read in everything
library(dplyr)
summary<-read.csv('Digital Marketing HW1 data set/DMEFExtractSummaryV01.csv')
lines<-read.csv('Digital Marketing HW1 data set/DMEFExtractLinesV01.csv')
orders<-read.csv('Digital Marketing HW1 data set/DMEFExtractOrdersV01.csv')
contacts<-read.csv('Digital Marketing HW1 data set/DMEFExtractContactsV01.csv')
contacts$ContactDate<- as.Date(as.character(contacts$ContactDate),format="%Y%m%d")
orders$OrderDate<- as.Date(as.character(orders$OrderDate),format="%Y%m%d")

#Create a table called 'rates' to capture response rates over time.
rates<-data.frame(season=c('07Fall','07Spr','06Fall','06Spr','05Fall','05Spr','04Fall','04Spr'))
rates<-cbind(rates,startDate=as.Date(c('2007-07-01','2007-01-01','2006-07-01','2006-01-01','2005-07-01','2005-01-01','2004-07-01','2004-01-01'),format="%Y-%m-%d"))
rates<-cbind(rates,endDate=as.Date(c('2007-12-31','2007-06-30','2006-12-31','2006-06-30','2005-12-31','2005-06-30','2004-12-31','2004-06-30'),format="%Y-%m-%d"))
rates$numberEmailed<-NA
rates$numberResponded<-NA
rates$E_responseRate<-NA
rates$numberCatalogued<-NA
rates$numberCatResponded<-NA
rates$C_responseRate<-NA


#Fill in 'numberEmailed' column, the number of people who were emailed during that season.
#And Fill in 'numberResponded' column, the number of people who were emailed and bought things in that seasond
for(i in 1:nrow(rates))
{srtdate=rates$startDate[i]
enddate=rates$endDate[i]

#get Cust_ids who were emailed within each season from contacts table.
aa<- filter(contacts, ContactDate%in% seq(srtdate,enddate, "day"), ContactType=="E")
#since many of those ids are repeated, I only want the unique ones.
ids_emailed<-select(aa,Cust_ID) %>% unique() 
#from that subset of unique ids who bought during each season?
bb <-filter(orders,Cust_ID %in% ids_emailed[,1], OrderDate%in% seq(srtdate,enddate, "day"))

#insert results into columns.
rates$numberEmailed[i]<-ids_emailed %>% count()
rates$numberResponded[i]<- select(bb,Cust_ID) %>% unique() %>% count()
}

rates$numberEmailed<-as.numeric(rates$numberEmailed)
rates$numberResponded<- as.numeric(rates$numberResponded)
rates$E_responseRate <-round((rates$numberResponded/rates$numberEmailed)*100,2)


#Same method as above, but now for Catalogues:
for(i in 1:nrow(rates))
{srtdate=rates$startDate[i]
enddate=rates$endDate[i]

aa<- filter(contacts, ContactDate%in% seq(srtdate,enddate, "day"), ContactType=="C")
ids_Catalogued<-select(aa,Cust_ID) %>% unique() 
bb <-filter(orders,Cust_ID %in% ids_Catalogued[,1], OrderDate%in% seq(srtdate,enddate, "day"))

rates$numberCatalogued[i]<-ids_Catalogued %>% count()
rates$numberCatResponded[i]<- select(bb,Cust_ID) %>% unique() %>% count()
}

rates$numberCatalogued<-as.numeric(rates$numberCatalogued)
rates$numberCatResponded<- as.numeric(rates$numberCatResponded)
rates$C_responseRate <-round((rates$numberCatResponded/rates$numberCatalogued)*100,2)

#write.csv(rates,"rates.csv",row.names = FALSE)

#Step 2) Graphs
rates<-read.csv("rates.csv")

library(ggplot2)

# Set up theme object for Jim's pretty plots:)
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

Emails <- rates %>% 
  ggplot(aes(x = season, y =responseRate )) +
  geom_point(shape = 21, colour = "#666666", fill = "#e6ab02", size = 3.5, 
             stroke = .75, position = "jitter", alpha = .5) +
  scale_y_continuous(labels = scales::comma) +
  xlab("Season") +
  ylab("Response Rate for Email Marketing Customers %") +
  theme_jim

Catalogues <- 
  qplot(data=rates,x = season, y =C_responseRate )
