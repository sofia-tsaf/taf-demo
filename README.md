# TAF Demo

To understand how we're using GitHub and TAF workflows for the SOFIA analysis,
we can create a minimal demo analysis that resembles a SOFIA analysis. The steps
are:

## 1 Create and clone GitHub repository

1.1 [Browser] open github.com, new repository, name it taf-demo, add a README file, create

1.2 [Browser] in github.com/your-username/taf-demo, select code and clone, click the clipboard icon to copy the URL to the clipboard

1.3 [RStudio] select File, Version Control, Git, paste the URL, create project

## 2 Make it a TAF repository

2.1 [RStudio] open .gitignore, edit and save so it looks like this:

```
bootstrap/data/*
bootstrap/software/*
data/*
model/*
output/*
report/*
.Rproj.user
*.Rproj
```

2.2 [RStudio] in the upper right-hand window, select the Git tab, stage the .gitignore file, commit, write a commit message saying "TAF .gitignore", commit, push

2.3 [File Explorer] browse to the repository on the hard drive, containing .gitignore, README.md, and taf-demo.Rproj (these files are not strictly needed, so let's create some actual TAF files)

2.4 [RStudio] install TAF from CRAN if not already installed, then run these commands in the R console:

```{r}
library(TAF)
taf.skeleton
```

2.5 [RStudio] in the Git tab, stage the four *.R files, commit, write a commit message saying "Empty TAF scripts", commit, push

## 3 Initialize data files

3.1 [File Explorer] copy [Tier3eg2Biomass with extaernal data source on BMSY.xlsx](https://github.com/arni-magnusson/taf-demo/raw/main/bootstrap/initial/data/Tier3eg2Biomass%20with%20extaernal%20data%20source%20on%20BMSY.xlsx) and [Tier3eg2BiomassSMSY.xlsx](https://github.com/arni-magnusson/taf-demo/raw/main/bootstrap/initial/data/Tier3eg2BiomassSMSY.xlsx) into bootstrap/initial/data

3.2 [RStudio] stage the two initial data files, commit, write a commit message saying "Add initial biomass and refpt data files", commit, push

3.3 [RStudio] create a DATA.bib template by running this command in the R console:

```{r}
draft.data(file=TRUE)
```

3.4 [RStudio] edit the bootstrap/DATA.bib file, filling in originator, title, and period (where applicable), so it looks like this:

```{bibtex}
@Misc{Tier3eg2Biomass with extaernal data source on BMSY.xlsx,
  originator = {Rishi Sharma},
  year       = {2021},
  title      = {Biomass values for Callista chione in Area X},
  period     = {2006-2018},
  access     = {Public},
  source     = {file},
}

@Misc{Tier3eg2BiomassSMSY.xlsx,
  originator = {Rishi Sharma},
  year       = {2021},
  title      = {Reference points for Callista chione in Area X},
  access     = {Public},
  source     = {file},
}
```

3.5 [RStudio] stage DATA.bib, commit, write a commit message saying "Add biomass and refpt metadata", commit, push

3.6 [RStudio] initialize the data by running this command in the in the R console:

```{r}
taf.bootstrap()
```

## 4 Edit TAF scripts

4.1 [RStudio] edit data.R so it looks like this, then commit and push:

```{r}
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
```

4.2 [RStudio] edit model.R so it looks like this, then commit and push:

```{r}
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
```

4.3 [RStudio] edit output.R so it looks like this, then commit and push:

```{r}
## Extract results of interest, write TAF output tables

## Before: results.csv (model)
## After:  results.csv (output)

library(TAF)

mkdir("output")

cp("model/results.csv", "output/results.csv")
```

4.4 [RStudio] edit report.R so it looks like this, then commit and push:

```{r}
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
```

## 5 Run TAF analysis

5.1 [RStudio] make sure you have all package dependencies installed:

```{r}
deps()
```

5.2 [RStudio] anyone can clone and run the entire analysis by running these two commands in the R console:

```{r}
taf.bootstrap()
sourceAll()
```

---

In practice, we make incremental changes to the TAF scripts (data.R, model.R, output.R, report.R) and run individual scripts, blocks of code, or lines to check if things are working.

To confirm that the entire analysis is reproducible and runs without errors, we remove the resulting folders (bootstrap/data, data, model, output, report) by running these commands in the R console,

```{r}
clean("bootstrap")
clean()
```

and then run the TAF analysis as shown in step 5.2.
