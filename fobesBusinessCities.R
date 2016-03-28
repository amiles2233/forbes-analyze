##Forbes Best Cities for Business Mapping

# Load Libraries
library(forbesListR) #devtools::install_github("abresler/forebesListR")
library(dplyr)
library(choroplethr)
library(RColorBrewer)
library(ggplot2)

# Read in Forbes Data
dat <- get_year_forbes_list_data(list="Best Cities for Business", year=2015)

#Summarize Number of Cities by State
bus <- dat %>%
    group_by(state) %>%
    summarize(cities=n_distinct(city))

bus$state <- tolower(bus$state) #Lowercase cities

#Read in Choroplethr Data
data("df_state_demographics")

# Merge with cities Data
df_state_demographics <- left_join(df_state_demographics, bus, by=c("region" = "state"))

#Fill NAs as 0 (States with no cities)
df_state_demographics[is.na(df_state_demographics)] <- 0

#Set value to be city
df_state_demographics$value <- df_state_demographics$cities

#Create Plot
choro1 <- StateChoropleth$new(df_state_demographics)
choro1$title = "Forbes' Best Cities for Business by State"
choro1$set_num_colors(1)
choro1$ggplot_polygon = geom_polygon(aes(fill = value), color = NA)
choro1$ggplot_scale = scale_fill_gradientn(name = "# Cities", 
                                           colours = brewer.pal(8, "Purples"))

#Display Plot
choro1$render()
