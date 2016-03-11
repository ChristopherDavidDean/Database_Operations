# 03/06/2015
# Dom Bennett/Chris Dean
# Add new Member information

setwd(file.path("D:","PhD Work", "R", "for_chris", "for_chris"))

# DIRS AND FILES
input.dir <- '0_data'
output.dir <- '3_members'
members.file <- 'members_test.csv'
geodata.file <- 'geodata_complete2.csv'
# if the output.dir doesn't exist, create it
if (!file.exists (output.dir)) {
  dir.create (output.dir)
}

# FUNCTIONS
findMember <- function (Member.description) {
  # avoid locale errors by converting to UTF-8
  Member.description <- enc2native (Member.description)
  # loop through each formation
  for (form in members) {
    # using regexpr (this returns T/F) to find match
    if (grepl (form, Member.description, ignore.case=TRUE)) {
      # if a match, break out of loop and return the match
      return (form)
    }
  }
  # if loop has completed w/o breakout return NA
  return (NA)
}

# INPUT
# read in list of formations as vector without levels
members <- read.csv (file.path (input.dir, members.file),
                        stringsAsFactors=FALSE)[,1]
# read in USGS data without factors
geodata <- read.csv (file.path (input.dir, geodata.file),
                     stringsAsFactors=FALSE)

# ADD TO FORMATIONNEW
# loop through each row in geodata
for (i in 1:nrow (geodata)) {
  # get row data
  row.element <- geodata[i,]
  # get formation description
  Member.description <- row.element[ ,"Formation"]
  # use findFormation() to get matching formation name
  member <- findMember(Member.description)
  # add to geodata
  geodata$MemberNew[i] <- member
}
n.missing <- sum (is.na (geodata$MemberNew))
n.uniques <- length (unique (geodata$MemberNew)) - 1  # ignore NA
cat ('\nFound [', n.uniques, '] members in USGS formation descriptions.
     [', n.missing, '/', nrow (geodata), '] without member name.', sep='')

# OUTPUT
geodata.missing <- geodata[is.na (geodata$FormationNew), ]
geodata.complete1 <- geodata[!is.na (geodata$FormationNew), ]
write.csv (geodata.missing, file.path (output.dir,
                                       'geodata_missing.csv'))
write.csv (geodata.complete1, file.path (output.dir,
                                        'geodata_complete2.1.csv'))