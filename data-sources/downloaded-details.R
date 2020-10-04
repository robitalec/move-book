# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)

# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')
taxed <- fread('data-sources/taxed-details.csv')

# Downloaded data
paths <- dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE)
size <- vapply(paths, file.size, 1)
nm <- as.integer(gsub('.csv', '', tstrsplit(paths, 'GPS/')[[2]]))

downloaded <- data.table(size, id = nm)

# Merge
withdetails <- merge(DT, details, on = 'id')


# Summary -----------------------------------------------------------------
DT <- merge(withdetails,
						unique(taxed, by = 'id')[, .(id, class, family)],
						on = 'id')
