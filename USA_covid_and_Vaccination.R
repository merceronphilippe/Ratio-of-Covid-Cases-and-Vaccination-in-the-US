library(ggplot2)
library(maps)
library(dplyr)
library(ggrepel)

States <- map_data("state")
cas <- read.csv("Casdecovid.csv")

ggplot() + 
  geom_polygon( data=States, aes(x=long, y=lat, group=group),
                color="black", fill="lightblue" )

MergedStates <- inner_join(States, cas, by = "region")
agg.data <- aggregate(cbind(long,lat,percentage.vaccination,percentage.cases) ~ code, data = MergedStates, mean)

  
p <- ggplot()
p <- p + geom_polygon( data=MergedStates, 
                       aes(x=long, y=lat, group=group, fill = total.cases/1000000), 
                       color="black", size = 0.2) 
p

p <- p + scale_fill_continuous(name="Total vaccination", 
                               low = "white", high = "red3",limits = c(0,40), 
                               breaks=c(5,10,15,20,25,30,35), na.value = "grey50") +
  
  labs(title="Total Cases and Vaccination per State in the US")
p

p <- p + geom_label_repel(data = agg.data, size = 2.5,
              aes(x = long, y = lat, 
                  label = paste("(",code,",",round(percentage.cases,digits = 1),",",round(percentage.vaccination, digits = 1),")")))
p                    
              
