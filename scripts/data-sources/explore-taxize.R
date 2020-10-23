# === Explore taxize ------------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)
library(taxize)


# Data --------------------------------------------------------------------
details <- fread('derived/data-sources/details.csv')

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

classify_taxon <- function(id, ranks) {
	z <- t(data.table(classification(id, db = 'ncbi')[[1]])[rank %in% ranks])
	zz <- data.table(z)[1]
	colnames(zz) <- z[2,]
	zz
}

taxes[, (ranks) := classify_taxon(matched_name, ranks)[, .SD, .SDcols = ranks],
			matched_name]



# TODO: add sign in to r environ

#careful, tax_name requires manual intervention...
# TODO: check messages = FALSE, ask = FALSE


# Summary -----------------------------------------------------------------
m <- merge(details, taxes,
					 by = 'taxon_ids',
					 all = TRUE)

# Output ------------------------------------------------------------------
fwrite(taxes, 'derived/data-sources/taxes.csv')

fwrite(m, 'derived/data-sources/taxed-details.csv')




# Warnings from tax_name --------------------------------------------------

# Warning messages:
# 	1: Aves: rank requested ('family') not in ITIS classification
# 2: Animalia: rank requested ('family, class') not in ITIS classification
# 3: > 1 result; no direct match found
# 4: > 1 result; no direct match found
# 5: Neovison vison: highest rank of ITIS classification is 'species'
# 6: Neovison vison: rank requested ('family, class') not in ITIS classification
# 7: Hieraaetus fasciatus: highest rank of ITIS classification is 'species'
# 8: Hieraaetus fasciatus: rank requested ('family, class') not in ITIS classification
# 9: Hieraaetus fasciatus: highest rank of ITIS classification is 'species'
# 10: Hieraaetus fasciatus: rank requested ('family, class') not in ITIS classification
# 11: Hieraaetus fasciatus: highest rank of ITIS classification is 'species'
# 12: Hieraaetus fasciatus: rank requested ('family, class') not in ITIS classification
# 13: Hieraaetus fasciatus: highest rank of ITIS classification is 'species'
# 14: Hieraaetus fasciatus: rank requested ('family, class') not in ITIS classification
# 15: > 1 result; no direct match found
# 16: Rousettus egyptiacus: highest rank of ITIS classification is 'species'
# 17: Rousettus egyptiacus: rank requested ('family, class') not in ITIS classification
# 18: Aves: rank requested ('family') not in ITIS classification
# 19: Carnivora: rank requested ('family') not in ITIS classification
# 20: Myotis bechsteini: highest rank of ITIS classification is 'species'
# 21: Myotis bechsteini: rank requested ('family, class') not in ITIS classification
# 22: Hieraaetus fasciatus: highest rank of ITIS classification is 'species'
# 23: Hieraaetus fasciatus: rank requested ('family, class') not in ITIS classification
# 24: Hydrochaeris hydrochaeris: highest rank of ITIS classification is 'species'
# 25: Hydrochaeris hydrochaeris: rank requested ('family, class') not in ITIS classification
# 26: Caprimulgus vociferus: highest rank of ITIS classification is 'species'
# 27: Caprimulgus vociferus: rank requested ('family, class') not in ITIS classification
# 28: Reptilia: rank requested ('family') not in ITIS classification
# 29: Amphibia: rank requested ('family') not in ITIS classification
# 30: Larus brunnicephalus: highest rank of ITIS classification is 'species'
# 31: Larus brunnicephalus: rank requested ('family, class') not in ITIS classification
# 32: Larus ichthyaetus: highest rank of ITIS classification is 'species'
# 33: Larus ichthyaetus: rank requested ('family, class') not in ITIS classification
# 34: Dama mesopotamica: highest rank of ITIS classification is 'species'
# 35: Dama mesopotamica: rank requested ('family, class') not in ITIS classification
# 36: Spermophilus franklinii: highest rank of ITIS classification is 'species'
# 37: Spermophilus franklinii: rank requested ('family, class') not in ITIS classification
# 38: > 1 result; no direct match found
# 39: Carduelis cannabina: highest rank of ITIS classification is 'species'
# 40: Carduelis cannabina: rank requested ('family, class') not in ITIS classification
# 41: Rousettus egyptiacus: highest rank of ITIS classification is 'species'
# 42: Rousettus egyptiacus: rank requested ('family, class') not in ITIS classification
# 43: Ibis: highest rank of ITIS classification is 'genus'
# 44: Ibis: rank requested ('family, class') not in ITIS classification
# 45: > 1 result; no direct match found
# 46: Geochelone pardalis: highest rank of ITIS classification is 'species'
# 47: Geochelone pardalis: rank requested ('family, class') not in ITIS classification
# 48: Corvus monedula: highest rank of ITIS classification is 'species'
# 49: Corvus monedula: rank requested ('family, class') not in ITIS classification
# 50: Cetacea: rank requested ('family') not in ITIS classification
