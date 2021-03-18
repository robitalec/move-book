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
library(rmoveapi)
library(keyring)


# Authentication setup ----------------------------------------------------
service = 'movebank'
username = 'robitalec'

# Only need to run this once
key_set(service, username)


# Data --------------------------------------------------------------------
# Authenticate
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))
options(rmoveapi.userid = key_list(service)[1, 2])
options(rmoveapi.pass = key_get(service, username))

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
# details <- readRDS('derived/details.Rds')

# Download data to disk
# Set download path
# downpath <- 'raw-data'

#  using the rmoveapi::getEvent function instead of move package
#  because it can download directly to disk

# Note: if you'd like to reduce the amount of data downloaded,
#       this would be a good place to do it!

# For example, if you'd only like to download GPS data replace details with gps
# gps <- details[grepl('GPS', sensor_type_ids)]

result <-
	details[, {
		path <- paste0(file.path(dlpath, .BY[[1]]), '.csv')
		success <- tryCatch(
			getEvent(
				studyid = .BY[[1]],
				attributes = 'all',
				save_as = path,
				accept_license = TRUE
			),
			error = function(e)
				as.character(e)
		)

		list(path, success)
	}, by = id]

# Next, take update the paths in the _targets.R file and
#  run with targets::tar_make()
