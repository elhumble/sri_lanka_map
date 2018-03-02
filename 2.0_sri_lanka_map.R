# Sri Lanka map

library(rgdal)
library(ggplot2)
library(maptools)
library(dplyr)
library(stringr)
options(scipen=999)
library(ggmap)
library(ggthemr)

# nicer map

library(ggthemr)
ggthemr(palette = "pale", layout = "clean",
        line_weight = 0.5, text_size = 16, type = "outer", spacing = 2)

markets <- c("Negambo", "Mirissa")
latlong <- geocode(markets)

markets <- data.frame(markets=markets, latlong) %>%
  mutate(vol = c(40,100))

sl_map <- borders("world", regions = "Sri Lanka", fill = "grey90", colour = "grey60")
sl_map <- borders("world", regions = "Sri Lanka", fill = "darkseagreen", colour = "grey60")

# Plot
lightsteelblue2

ggplot() + sl_map + 
  #geom_polygon(fill = "darkseagreen") +
  #geom_path(colour = "grey40") + 
  geom_point(data = markets,
             aes(x = lon, y = lat, size = vol), alpha = 0.8) +
  coord_quickmap() +   # Define aspect ratio of the map, so it doesn't get stretched when resizing
  theme(panel.grid.major = element_line(colour = "grey90"),
    #panel.grid.major = element_blank(),
    #panel.grid.minor = element_blank(),
    axis.ticks = element_blank(), 
    axis.text.x = element_text (size = 14, vjust = 0), 
    #panel.background = element_rect(fill = "lightsteelblue2",
    #                                colour = "lightsteelblue2",
                               #     size = 0.5, linetype = "solid"),
    axis.text.y = element_text (size = 14, hjust = 1.3)) + 
  #coord_cartesian(xlim = longlimits, ylim = latlimits) + 
  xlim(78.5, 83) +  # Set x axis limits, xlim(min, max)
  ylim(5, 10.5) +  # 
  #scale_y_continuous(breaks=seq(-65,-45,10), labels = c("-65ºS", "-55ºS", "-45ºS")) + 
  #scale_x_continuous(breaks=seq(-70,-30,20), labels = c("-70ºW", "-50Wº" ,"-30ºW")) + 
  labs(y="",x="")


#~~ Alternative method

gpclibPermit()
world.map <- readOGR(dsn="data/raw/", layer="TM_WORLD_BORDERS-0.3")
world.map <- readOGR(dsn="data/raw/", layer="Boundary") # not lat longs
world.map <- readOGR(dsn="data/raw/LKA_adm_shp/", layer="LKA_adm0") # using this one

world.ggmap <- fortify(world.map, region = "NAME")
world.ggmap <- fortify(world.map)

n <- length(unique(world.ggmap$id))

markets <- read.csv("data/processed_market_latlongs.csv")
colnames(markets) <- c("market", "long", "lat")

# This bit is pretty hacky
markets <- markets %>%
  mutate(lon2 = long,
         lat2 = lat,
         market = as.character(market))

# So is this bit
test <- full_join(world.ggmap, markets, by = c("long", "lat")) %>%
  mutate(long = ifelse(!is.na(lon2), NA, long),
         lat = ifelse(!is.na(lat2), NA, lat),
         market2 = ifelse(grepl("^T", market), market, NA),
         market = ifelse(grepl("^T", market), NA, market))

png("figs/SL_map.png", units = "in", res = 300, width = 8, height = 8)

ggplot(test, aes(map_id = id)) +
  geom_map(colour = "grey40", fill = "white", size = 0.1, map = test) +
  expand_limits(x = test$long, y = test$lat) +
  geom_point(x = test$lon2, y = test$lat2, alpha = 0.6, col = "darkgreen") +
  geom_text(data = test, aes(x = lon2, y = lat2, label = market),
            hjust = 1.1, size = 3) +
  geom_text(data = test, aes(x = lon2, y = lat2, label = market2),
            hjust = -0.1, size = 3) +
  xlim(78.5, 83) +
  ylim(5, 10.5) +
  theme(axis.ticks = element_blank())

dev.off()
