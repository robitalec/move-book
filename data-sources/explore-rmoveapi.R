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

mammals[1:2, getEvent(
	studyid = id
	save_as = ,
	accept_license = TRUE
), by = id]
