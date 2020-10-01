# === Explore rmoveapi ----------------------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
# remotes::install_github('benscarlson/rmoveapi')
library(rmoveapi)
library(keyring)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')
DT <- fread('data-sources/taxed-details.csv')


# Credentials -------------------------------------------------------------
service = 'movebank'
username = 'robitalec'


# Explore -----------------------------------------------------------------
setAuth(key_list(service)[1, 2], key_get(service, username))


ustudies <- unique(DT, by = 'id')
mammals <- ustudies[class == 'Mammalia']

mammals[, tryCatch(
	getEvent(
		studyid = .BY[[1]],
		attributes = 'all',
		save_as = paste0('/media/Backup Plus/Movebank/Mammalia/', .BY[[1]], '.csv'),
		accept_license = TRUE
	),
	error = function(e)
		NULL
), by = id]

# Error in getMvData(req, ...) : Internal Server Error (HTTP 500).
