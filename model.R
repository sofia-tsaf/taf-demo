## Run analysis, write model results

## Before: bio.csv, ref.csv (data)
## After:  results.csv (model)

library(TAF)

mkdir("model")

## Read data
bio <- read.taf("data/bio.csv")
ref <- read.taf("data/ref.csv")
results <- bio

## Calculate relative biomass
results$Relative <- bio$Biomass / ref$Bmsy

## Assign category
labels <- c("Overfished", "Fully fished", "Underfished")
results$Category <- cut(results$Relative, c(0,0.8,1.2,Inf), labels=labels)

## Write results
write.taf(results, dir="model")
