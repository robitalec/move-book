# === Explore taxize ------------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(taxize)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')



# Taxize ------------------------------------------------------------------
details[is.null(taxon_ids), .N]
details[is.na(taxon_ids), .N]
details[taxon_ids == "", .N]


# First resolve the submitted name
resolved <- gnr_resolve(details$taxon_ids, best_match_only = TRUE)

setDT(resolved)
# details[, resolved := list(gnr_resolve(taxon_ids))]
