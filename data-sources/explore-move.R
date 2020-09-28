# === Explore move(bank) --------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
# install.packages('move')
library(move)

library(data.table)

library(keyring)


# Credentials -------------------------------------------------------------
service = 'movebank'
username = 'robitalec'

# keyring::key_set(service = service, username = username)


# Explore -----------------------------------------------------------------
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))

# Get all the studies
studies <- getMovebankStudies(login)


## Skip down to next section with try block
# Movebank has no automated/complete database to download
# Therefore, we'll loop through all the studies, get the details,
# and summarize how much data is actually accessible
details <- rbindlist(lapply(studies, getMovebankStudy, login = login))

# Error: There was more than one study with the name: X
# How many times does this occur? 17 unique studies, 88 rows (2020-09-04)
morethanone <- data.table(study = studies)[, .N, by = study][N > 1]

# Only unique studies
substudies <- studies[!studies %in% morethanone$study &
												!grepl('Test', studies)]
details <- rbindlist(lapply(substudies, getMovebankStudy, login = login),
										 fill = TRUE, use.names = TRUE)


# From: https://github.com/benscarlson/rmoveapi
# Certain studies require you to accept license terms before downloading any data. One way to do this is to accept these terms on movebank.com. Terms can also be accepted over the api by using accept_license=TRUE in the request for data.


data.table(study = studies)[, .N, by = study][grepl('Vulture', study) & grepl('Movements', study)]
# study     N
# <char> <int>
# 1:  VultureMovements     1
# 2: Vulture Movements     1
# 3: VultureMovements2     1
getMovebankStudy('VultureMovements', login = login)
# Error in getMovebankID(study, login) :
# There was more than one study with the name: VultureMovements
# Calls: getMovebankStudy -> getMovebankStudy -> getMovebankID -> getMovebankID
getMovebankStudy('Vulture Movements', login = login)
# Error in getMovebankID(study, login) :
# There was more than one study with the name: Vulture Movements
# Calls: getMovebankStudy -> getMovebankStudy -> getMovebankID -> getMovebankID

lapply(studies[1:5], getMovebankID, login = login)

getMovebankStudy('Vulture Movements', login = login)



# Nonsense study names
data.table(studies)[c(16, 18:30, 35, 61:69, 72, 73, 435, 544, 744, 996, 1067, 2455, 2706, 3036:3037, 3365, 3390:3395, 3453:3481, 3498, 3677, 4033, 4059)]



# Details with try --------------------------------------------------------
get_details <- function(study) {
	tryCatch(expr = getMovebankStudy(study, login = login),
					 error = function(cond) return(list(error = as.character(cond))),
					 warning = function(cond) return(list(warning = as.character(cond))))
}

details <- rbindlist(lapply(studies, get_details),
										 fill = TRUE, use.names = TRUE)

saveRDS(details, 'data-sources/details.Rds')
fwrite(details, 'data-sources/details.csv')

details <- fread('data-sources/details.csv')
# Warning message:
# 	In require_bit64_if_needed(ans) :
# 	Some columns are type 'integer64' but package bit64 is not installed. Those columns will print as strange looking floating point data. There is no need to reload the data. Simply install.packages('bit64') to obtain the integer64 print method and print the data again.
# Calls: fread -> require_bit64_if_needed

colnames(details)
details[, .N, go_public_license_type]
details[, .N, has_quota]

details[, .N, i_can_see_data]
details[, .N, there_are_data_which_i_cannot_see]
details[, .N, i_have_download_access]

details[, .N, sensor_type_ids]

# TODO try again after sign licenses

# TODO: try and get range, some not matching default POSIXct format
details[timestamp_first_deployed_location != "" &
					timestamp_last_deployed_location != "", .N,
				as.POSIXct(timestamp_last_deployed_location) -
					as.POSIXct(timestamp_first_deployed_location)]

hist <- function(...) ggplot2::qplot(..., type = 'histograph')
details[, hist(number_of_deployments)]
details[, hist(number_of_individuals)]
details[, hist(number_of_tags)]
details[, hist(number_of_deployed_locations)]

details[, .N, taxon_ids]


# TODO
# details[, mapview(main_location_lat)]

# to explore further
details[, .N, license_type]
details[, .N, license_terms]

details[, .N, suspend_go_public_date]
details[, .N, suspend_license_terms]

details[, .N, principal_investigator_email]


View(details[taxon_ids == 'Rangifer tarandus', .(
	name,
	license_terms,
	sensor_type_ids,
	number_of_individuals,
	number_of_deployed_locations,
	principal_investigator_name,
	there_are_data_which_i_cannot_see,
	i_have_download_access,
	timestamp_first_deployed_location,
	timestamp_last_deployed_location
)])

details[taxon_ids == 'Rangifer tarandus', .(
	name,
	license_terms,
	i_have_download_access
)]

details[taxon_ids == 'Rangifer tarandus' & i_have_download_access]

details[order(taxon_ids)][(i_have_download_access), View(.SD), .SDcols = c('taxon_ids', 'number_of_individuals', 'i_have_download_access', 'license_terms')]



# download all and narrow down to useful then worry about license/contact later?
