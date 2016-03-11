# Fake Database

  geodata <- read.csv("D://PhD Work/Projects/ARAG BIAS/R//CAMPANIAN//V1//1_formations//geodata_complete2.csv")

  ############## TESTING ###############

trim.leading <- function (x)  sub("^\\s+", "", x)  
  
species <- list()

for (i in 1:nrow (geodata)) {
    # extract row element - i.e. each row.
    row.element <- geodata[i, ]
    # split fauna string by ','
    species.description <- row.element[ ,'Resume_of_Fauna']
    species.description <- gsub ('\\([^\\)]*\\)', '', species.description)
    # remove all things in []
    species.description <- gsub ('\\[[a-zA-Z]*\\]', '', species.description)
    # remove all things in <>
    species.description <- gsub ('<[^>]*>', '', species.description)
    # Add a comma to the end to help with sorting
    species.description <- paste0(species.description, ",")
    # add species to a list
    species[[i]] <- gsub("^_|_$", "", unlist(strsplit(species.description, split=",")))
}

res <- geodata[1, ]
res$species <- NA

for (i in 1:nrow(geodata)) {   
  for (s in 1:length(species[[i]])) {
    row.element <- geodata[i, ] 
    new.row.element <- row.element
    new.row.element$species <- trim.leading(species[[i]][s])
    res <- rbind (res, new.row.element)
  }
}

res <- res[-1, ]
uniqspp <- sort (unique (res$species))

cat ('\nCreated dataframe of [', nrow (res), '].
     Identifed [', length (uniqspp), '] unique species.',
     sep='')


# OUTPUT

output.dir <- '2_species'
# if the output.dir doesn't exist, create it
if (!file.exists (output.dir)) {
  dir.create (output.dir)
}

write.table (uniqspp, file=file.path (output.dir, 'names.txt'),
             row.names=FALSE, col.names=FALSE, quote=FALSE)
  
write.csv (res, file=file.path (output.dir, 'geodata.csv'))


#### DATE CLEANING ####


Date <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

Ammdata <- read.csv("D://PhD Work/Database/USGS/Database Cleaning 27 7 15/2_species/SecondTestAmmsTightAge1.csv")

Ammdata[] <- lapply(Ammdata, as.character)

Ammdata$ShortDate <- NA

for (i in (1:nrow(Ammdata))){
  row.element <- Ammdata[i,16]
  num <- Date(row.element,4)
  if (grepl("/0",num)==TRUE){
    substring(num, 1, 2) <- c("20")
  }
  if(grepl("/",num)==TRUE){
    substring(num, 1, 2) <- c("19")
  }
  Ammdata$ShortDate[i] <- num
}

install.packages("xlsx")
library(xlsx)
library(rJava)

write.xlsx(Ammdata, "D://PhD Work/Database/USGS/Database Cleaning 27 7 15/2_species/R_edited_with_dates.xlsx", sheetName="Sheet1", 
           col.names=TRUE, row.names=TRUE, append=FALSE)

