## Extract results of interest, write TAF output tables

## Before: results.csv (model)
## After:  results.csv (output)

library(TAF)

mkdir("output")

cp("model/results.csv", "output/results.csv")
