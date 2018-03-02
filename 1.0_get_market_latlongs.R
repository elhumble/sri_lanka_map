# Code to save dataframe of Market locations and latlongs using google apis

library(rgdal)
library(ggplot2)
library(maptools)
library(dplyr)
library(stringr)
options(scipen=999)
library(ggmap)
library(ggthemr)

#~~ market locations

marketsA <- c("Negombo", "Mirissa")
marketsA_LL <- geocode(marketsA)
marketsA_LL <- data.frame(market=marketsA, marketsA_LL)

marketsB <- c("Beruwela", "Galle")
marketsB_LL <- geocode(marketsB)
marketsB_LL <- data.frame(market=marketsB, marketsB_LL)

marketsC <- c("Trincomalee", "Beruwela")
marketsC_LL <- geocode(marketsC)
marketsC_LL <- data.frame(market=marketsC, marketsC_LL)

marketsD <- c("Tagalle", "Sudawella")
marketsD_LL <- geocode(marketsD)
marketsD_LL <- data.frame(market=marketsD, marketsD_LL)

markets_LL <- rbind(marketsA_LL, marketsB_LL,
                    marketsC_LL, marketsD_LL)

write.csv(markets_LL, "data/processed_market_latlongs.csv",
          quote = F, row.names = F)
