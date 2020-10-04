# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)

# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')
taxed <- fread('data-sources/taxed-details.csv')

# Downloaded data
paths <- dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE)
size <- vapply(paths, file.size, 1)
nm <- as.integer(gsub('.csv', '', tstrsplit(paths, 'GPS/')[[2]]))

downloaded <- data.table(size, id = nm)

# Merge
withdetails <- merge(downloaded, details, on = 'id')


# Summary -----------------------------------------------------------------
# Expected
gps <- unique(taxed, by = 'id')[
	grepl('GPS', sensor_type_ids) & (i_have_download_access)]

# Actually downloaded
DT <- merge(withdetails,
						unique(taxed, by = 'id')[, .(id, class, family)],
						on = 'id')

sub <- DT[!(family == '' | class == '')]

sub[, qplot(family) + facet_wrap(~class)]



# Combine -----------------------------------------------------------------
# No point rbindlist + freading them all
# TODO: write single input script to
#       taxon, number of individuals, is it actually GPS?
#       drop Argos, number of years, number of locs etc
#       write to summary csv, keep appending
#       bash script Rscript run on all in folder

# zzz <- rbindlist(lapply(paths, fread),
# 								 use.names = TRUE, fill = TRUE)
