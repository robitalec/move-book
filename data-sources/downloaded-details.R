# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')

size <- vapply(dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE), file.size, 1)
nm <- tstrsplit(dir('/media/Backup Plus/Movebank/GPS'), '.csv', type.convert = TRUE)[[1]]

DT <- data.table(size, id = nm)


# Merge -------------------------------------------------------------------
DT[details, on = 'id']
