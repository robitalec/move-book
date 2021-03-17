# === Setup ---------------------------------------------------------------
# Alec Robitaille ---------------------------------------------------------



# Packages ----------------------------------------------------------------
# Install renv
install.packages('renv')

# Load renv and restore package version from the lock file
library(renv)
restore()

# Load packages
library(data.table)
library(move)
library(keyring)



# Authentication setup ----------------------------------------------------
service = 'movebank'
username = 'robitalec'

# Only need to run this once
key_set(service, username)



# Data --------------------------------------------------------------------
# Authenticate
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))

# Get all study names
studies <- getMovebankStudies(login)

# Get details for each study or return error/warning
get_all_studies <- function(study) {
	tryCatch(expr = getMovebankStudy(study, login = login),
					 error = function(cond) return(list(error = as.character(cond))),
					 warning = function(cond) return(list(warning = as.character(cond))))
}

# Combine results
details <- rbindlist(lapply(studies, get_all_studies),
										 fill = TRUE, use.names = TRUE)


# Save details
saveRDS(details, 'derived/details.Rds')



ustudies <- unique(DT, by = 'id')
mammals <- ustudies[class == 'Mammalia']

mammals[, tryCatch(
	getEvent(
		studyid = .BY[[1]],
		attributes = 'all',
		save_as = paste0('/media/ICEAGE/Movebank/Mammalia/', .BY[[1]], '.csv'),
		accept_license = TRUE
	),
	error = function(e)
		NULL
), by = id]
