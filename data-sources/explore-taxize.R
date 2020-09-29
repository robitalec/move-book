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
details[taxon_ids == '', .N]



# Loop over each
sort_resolved <- function(tax) {
	data.table(gnr_resolve(tax))[, .SD[order(score)][1], user_supplied_name]
}

cols <- c('user_supplied_name', 'submitted_name', 'matched_name',
					'data_source_title', 'score')
subdet <- details[taxon_ids != '']
taxes <- subdet[, rbindlist(lapply(strsplit(taxon_ids, ','), sort_resolved),
														fill = TRUE, use.names = TRUE),
								by = taxon_ids]
taxes



resolved <- lapply(details$taxon_ids[sample(details[, .N], 5)],
									 function(tax) lapply(gnr_resolve)

									 lapply(strsplit(details$taxon_ids[[997]], ','), function(tax) data.table(gnr_resolve(tax))[, .SD[order(score)][1], user_supplied_name])




# First resolve the submitted name
resolved <- gnr_resolve(details$taxon_ids, best_match_only = TRUE)

setDT(resolved)
# details[, resolved := list(gnr_resolve(taxon_ids))]
