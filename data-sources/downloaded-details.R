# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(taxizt)

# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')

# Downloaded data
paths <- dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE)
size <- vapply(paths, file.size, 1)
nm <- as.integer(gsub('.csv', '', tstrsplit(paths, 'GPS/')[[2]]))

DT <- data.table(size, id = nm)

# Merge
down <- merge(DT, details, on = 'id')


# Summary -----------------------------------------------------------------
# Quick taxon family for first char listed in taxon_ids
# TODO: use these everywhere, more options for taxize
down[, family := tax_name(tstrsplit(taxon_ids, ',')[[1]],
													'family',
													messages = FALSE,
													ask = FALSE,
													accepted = TRUE)$family]

