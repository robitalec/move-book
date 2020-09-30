# === Explore taxize ------------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(taxize)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')

details[, record_id := .I]

# Taxize ------------------------------------------------------------------
details[is.null(taxon_ids), .N]
details[is.na(taxon_ids), .N]
details[taxon_ids == '', .N]



# Resolve the taxon_ids column with taxize
# Sort each resolved taxon_id (splitting lists) by score, preserving the top
sort_resolved <- function(tax) {
	data.table(gnr_resolve(tax))[, .SD[order(score)][1], user_supplied_name]
}

# Drop where taxon_ids is ""
subdet <- details[taxon_ids != '']

# Apply over each (potential) list within taxon_ids row, sorting resolved
taxes <- subdet[, rbindlist(lapply(strsplit(taxon_ids, ','), sort_resolved),
														fill = TRUE, use.names = TRUE),
								by = taxon_ids]


# Get eg. family and class
ranks <- c('family', 'class')
taxes[, (ranks) := tax_name(matched_name, ranks, messages = FALSE)[, ranks]]

#careful, tax_name requires manual intervention...

# Summary -----------------------------------------------------------------
m <- merge(details, taxes,
					 by = 'taxon_ids',
					 all = TRUE)

# Output ------------------------------------------------------------------
fwrite(taxes, 'data-sources/taxes.csv')

fwrite(m, 'data-sources/taxed-details.csv')
