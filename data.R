## Preprocess data, write TAF data tables

## Before: Tier3eg2Biomass with extaernal data source on BMSY.xlsx,
##         Tier3eg2BiomassSMSY.xlsx (bootstrap/data)
## After:  bio.csv, ref.csv (data)

library(TAF)
library(openxlsx)

mkdir("data")

## Read original data files
bio <- read.xlsx("bootstrap/data/Tier3eg2Biomass with extaernal data source on BMSY.xlsx")
ref <- read.xlsx("bootstrap/data/Tier3eg2BiomassSMSY.xlsx")

## Clean up
names(bio)[2] <- "Year"
names(ref)[2] <- "Bmsy"

## Filter data
bio <- bio[bio$Stock=="Callista.chione",]

## Write TAF tables
write.taf(bio, dir="data")
write.taf(ref, dir="data")
