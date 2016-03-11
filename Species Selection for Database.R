### CLEANING DATABASE FOR GROUPED FOSSILS ###

ammList <- read.csv("D://PhD Work/Database/USGS/Database Cleaning 7 10 15/2_species/geodataAmmOnly.csv")

generalList <- read.csv("D://PhD Work/Database/USGS/Database Cleaning 7 10 15/2_species/geodata.csv")

# Generate Unique list of ammonites
Amms <- unique(ammList$species)

# Remove brackets to avoid issues with grepl
Amms <- gsub ('\\()', '', Amms)

numbers <- c()

# Search through general list for any ammonites and make a note of the row number
for (i in 1:nrow(generalList)){
  row.element <- generalList[i, ]
  # split fauna string by ','
  species.description <- row.element[ ,'species']
  species.description <- gsub ('\\()', '', species.description)

  for (s in Amms){
    if (s == species.description){
    ps <- i
    numbers[[i]] <- ps
    }
  }
}

# Remove NAs from list of row numbers
numbers <- na.omit(numbers)

# Function to remove rows with ammonites
removeRows <- function(rowNum, data) {
  newData <- data[-rowNum, , drop = FALSE]
  rownames(newData) <- NULL
  newData
}

# Save as dataframe
NewGeneralList <- removeRows(numbers,generalList)

library(xlsx)
library(rJava)

# Write to new spreadsseet
write.xlsx(NewGeneralList, "D://PhD Work/Database/USGS/Database Cleaning 7 10 15/NonAmmsGeneralv1.xlsx", sheetName="Sheet1", 
           col.names=TRUE, row.names=TRUE, append=FALSE)

