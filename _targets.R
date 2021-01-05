library(targets)
library(tarchetypes)

# Source functions
source('scripts/functions.R')


# Packages
library(data.table)
library(rmoveapi)
library(keyring)
library(move)

# Paths
if (.Platform$OS.type == "windows") {
	downpath <- file.path('E:', 'ALR_C2', 'All')
	outpath <- file.path('E:', 'ALR_C2', 'Summary')
} else if (.Platform$OS.type == "unix") {
	downpath <- file.path('/media', 'ICEAGE', 'Movebank', 'All')
	outpath <- file.path('/media', 'ICEAGE', 'Movebank', 'Summary', 'All')
}

# Credentials
service = 'movebank'
username = 'robitalec'
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))
options(rmoveapi.userid = key_list(service)[1, 2])
options(rmoveapi.pass = key_get(service, username))


# Targets: options
tar_option_set(error = "workspace")

# Targets: workflow
list(
	tar_files(paths,
						sample(dir(downpath, '.csv', full.names = TRUE), 100)),
	tar_target(checked,
						 as.data.table(check_input(paths)),
						 pattern = map(paths)),
	tar_target(filtered, checked[is.na(why)])
)
