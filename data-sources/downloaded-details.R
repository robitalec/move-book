# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')

paths <- dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE)
size <- vapply(paths, file.size, 1)
nm <- as.integer(gsub('.csv', '', tstrsplit(paths, 'GPS/')[[2]]))

DT <- data.table(size, id = nm)

down <- merge(DT, details, on = 'id')
