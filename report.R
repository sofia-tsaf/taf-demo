## Prepare plots and tables for report

## Before: results.csv (output)
## After:  categories.png (report)

library(TAF)

mkdir("report")

## Read results
results <- read.taf("output/results.csv")

## Plot categories
taf.png("categories")
levels <- c("Underfished", "Fully fished", "Overfished")
results$Category <- factor(results$Category, levels=levels, ordered=TRUE)
col <- c("#61D04F", "#F5C710", "#DF536B")  # R 4.x standard palette
barplot(table(results$Category), col=col)
dev.off()
