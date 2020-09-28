# === Explore taxize ------------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(taxize)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')



# Taxize ------------------------------------------------------------------
# First resolve the submitted name
resolved <- gnr_resolve(details$taxon_ids)
# details[, resolved := list(gnr_resolve(taxon_ids))]
